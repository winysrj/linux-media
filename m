Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAK00eCH018197
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 19:00:40 -0500
Received: from mk-outboundfilter-2.mail.uk.tiscali.com
	(mk-outboundfilter-2.mail.uk.tiscali.com [212.74.114.38])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAK00RH9001619
	for <video4linux-list@redhat.com>; Wed, 19 Nov 2008 19:00:28 -0500
From: Adam Baker <linux@baker-net.org.uk>
To: video4linux-list@redhat.com
Date: Thu, 20 Nov 2008 00:00:25 +0000
References: <4923DC47.6010101@hhs.nl>
In-Reply-To: <4923DC47.6010101@hhs.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811200000.25760.linux@baker-net.org.uk>
Cc: =?windows-1252?q?Luk=E1=9A_Karas?= <lukas.karas@centrum.cz>
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

On Wednesday 19 November 2008, Hans de Goede wrote:
> Hi All,
>
<snip>
>
> This has been discussed at the plumbers conference, and there the solution
> we came up with for "does this cam need software whitebalance?" was
> (AFAIK), check if has a V4L2_CID_AUTO_WHITE_BALANCE, if it does not do
> software whitebalance. This of course means we will be doing software
> whitebalance on things like framefrabbers etc. too, so the plan was to
> combine this with an "is_webcam" flag in the capabilities struct. The
> is_webcam workaround, already shows what is wrong with this approach, we
> are checking for something not being there, were we should be checking for
> the driver asking something actively,

There also seem to be so many things we might want to control that such an 
inference based system is going to hit other limitations.

>
> So we need an extensible mechanism to query devices if they could benefit
> from certain additional processing being done on the generated image data.
>
> This sounds a lot like the existing mechanism for v4l2 controls, except
> that these are all read only controls, and not controls which we want to
> show up in v4l control panels like v4l2ucp.
>
> Still I think that using the existing controls mechanism is the best way
> todo this, so therefor I propose to add a number of standard CID's to query
> the things listed above. All these CID's will always be shown by the driver
> as readonly and disabled (as they are not really controls).
>

I can see this leading to a lot of drivers having to implement a whole bunch 
of cases in a switch statement to handle these values. Could a simpler 
approach be to have a single ioctl to query the set of controls the driver 
would like to have implemented and the driver then responds with the list of 
tags and default values for the controls it would like implemented.

Someting like:

struct tag
{
u32	tag_id;
u32	tag_value;
};

const tag default_tags[] = { {LIBV4L_CTL_GAMMA, 0x34}, 
{LIBV4L_CTL_LRFLIP,1} };

This could also be a mechanism to address your other RFC as to how to store 
the current settings. The fact that you are already adding code to the kernel 
to provide the list of controls somewhat argues against your point that you 
don't want to add code to the kernel to store the current control settings.
The driver could therefore copy the default control values into somewhere in 
it's device struct to provide a per device instance volatile storage for the 
data.

The reason I prefer in driver storage is that it simplifies the task of 
associating the data with the device. If you have a machine with multiple 
webcams they need to have independent sets of controls per device and you 
shouldn't retain the previous values if the user unplugs one webcam and plugs 
in another that gets the same /dev/videox name.

If you do use shared memory have you considered wheter to use the SysV or 
Posix variant? Both variants provide the required retain while not in use 
functionality but have different naming rules.

Is it necessary to provide a mechanism to notify other libv4l instances that 
the set values have changed? With driver stored values I think it is but if 
you use shared memory they could simply be read each time a frame is 
received.

Adam

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
