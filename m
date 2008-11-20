Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAK8aCbk028184
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 03:36:12 -0500
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAK8ZhBa016934
	for <video4linux-list@redhat.com>; Thu, 20 Nov 2008 03:35:55 -0500
Message-ID: <492522AA.8020807@hhs.nl>
Date: Thu, 20 Nov 2008 09:41:14 +0100
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Adam Baker <linux@baker-net.org.uk>
References: <4923DC47.6010101@hhs.nl>
	<200811200000.25760.linux@baker-net.org.uk>
In-Reply-To: <200811200000.25760.linux@baker-net.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	=?windows-1252?Q?Luk=E1=9A_Karas?= <lukas.karas@centrum.cz>
Subject: Re: RFC: API to query webcams for various webcam specific properties
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Adam Baker wrote:
> On Wednesday 19 November 2008, Hans de Goede wrote:
>> Hi All,
>>
> <snip>
>> This has been discussed at the plumbers conference, and there the solution
>> we came up with for "does this cam need software whitebalance?" was
>> (AFAIK), check if has a V4L2_CID_AUTO_WHITE_BALANCE, if it does not do
>> software whitebalance. This of course means we will be doing software
>> whitebalance on things like framefrabbers etc. too, so the plan was to
>> combine this with an "is_webcam" flag in the capabilities struct. The
>> is_webcam workaround, already shows what is wrong with this approach, we
>> are checking for something not being there, were we should be checking for
>> the driver asking something actively,
> 
> There also seem to be so many things we might want to control that such an 
> inference based system is going to hit other limitations.
> 
>> So we need an extensible mechanism to query devices if they could benefit
>> from certain additional processing being done on the generated image data.
>>
>> This sounds a lot like the existing mechanism for v4l2 controls, except
>> that these are all read only controls, and not controls which we want to
>> show up in v4l control panels like v4l2ucp.
>>
>> Still I think that using the existing controls mechanism is the best way
>> todo this, so therefor I propose to add a number of standard CID's to query
>> the things listed above. All these CID's will always be shown by the driver
>> as readonly and disabled (as they are not really controls).
>>
> 
> I can see this leading to a lot of drivers having to implement a whole bunch 
> of cases in a switch statement to handle these values. Could a simpler 
> approach be to have a single ioctl to query the set of controls the driver 
> would like to have implemented and the driver then responds with the list of 
> tags and default values for the controls it would like implemented.
> 
> Someting like:
> 
> struct tag
> {
> u32	tag_id;
> u32	tag_value;
> };
> 
> const tag default_tags[] = { {LIBV4L_CTL_GAMMA, 0x34}, 
> {LIBV4L_CTL_LRFLIP,1} };
> 

Yes, implementing v4l2 controls in drivers can take up quite a bit of code. 
This is a general problem though, not limited to my proposal for new CID's for 
the device/driver to be able to give hints to userspace that certain 
post-processing would be good todo.

We really need to add some framework code to the v4l2 core to make handling 
controls at the driver level easier.

What I envision is at the end having something like you propose above in the 
driver, and then have the v4l2 core do the translating to / from v4l2 control 
calls.

> This could also be a mechanism to address your other RFC as to how to store 
> the current settings. The fact that you are already adding code to the kernel 
> to provide the list of controls somewhat argues against your point that you 
> don't want to add code to the kernel to store the current control settings.
> The driver could therefore copy the default control values into somewhere in 
> it's device struct to provide a per device instance volatile storage for the 
> data.
> 
> The reason I prefer in driver storage is that it simplifies the task of 
> associating the data with the device. If you have a machine with multiple 
> webcams they need to have independent sets of controls per device and you 
> shouldn't retain the previous values if the user unplugs one webcam and plugs 
> in another that gets the same /dev/videox name.
> 
> If you do use shared memory have you considered wheter to use the SysV or 
> Posix variant? Both variants provide the required retain while not in use 
> functionality but have different naming rules.
> 
> Is it necessary to provide a mechanism to notify other libv4l instances that 
> the set values have changed? With driver stored values I think it is but if 
> you use shared memory they could simply be read each time a frame is 
> received.

Yes, the idea is to simply read the values each frame, which is why shared 
memory is prefered as a solution to this. Your worries can be solved by simply 
putting the "card" member of the v4l2_capability struct + the minor no in the 
shared memory segment name / id.

Regards,

Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
