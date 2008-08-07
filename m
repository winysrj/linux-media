Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id m77BaKui016746
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 07:36:20 -0400
Received: from smtp2.versatel.nl (smtp2.versatel.nl [62.58.50.89])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id m77BZrca022039
	for <video4linux-list@redhat.com>; Thu, 7 Aug 2008 07:35:54 -0400
Message-ID: <489AE048.70708@hhs.nl>
Date: Thu, 07 Aug 2008 13:45:12 +0200
From: Hans de Goede <j.w.r.degoede@hhs.nl>
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart@skynet.be>
References: <489AD045.7030404@hhs.nl>
	<200808071237.47230.laurent.pinchart@skynet.be>
In-Reply-To: <200808071237.47230.laurent.pinchart@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com
Subject: Re: RFC: adding a flag to indicate a webcam sensor is installed
 upside down
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

Laurent Pinchart wrote:
> On Thursday 07 August 2008, Hans de Goede wrote:
>> Hi all,
>>
>> I have this Philips SPC 200NC webcam, which has its sensor installed upside 
>> down and the sensor does not seem to support flipping the image. So I
>> believe the windows drivers fix this little problem in software.
>>
>> I would like to add a flag somewhere to indicate this to userspace (and then 
>> add flipping code to libv4l).
>>
>> I think the best place for this would the flags field of the v4l2_fmtdesc 
>> struct. Any other ideas / objections to this?
> 
> More often than sensors being mounted upside down in a webcam, what I've noticed frequently is webcam modules being mounted upside down in a laptop screen. There is no way that I'm aware of to check the module orientation based on the USB descriptors only. We will need a pure userspace solution.
> 

Interesting, still in my case it can be told from just the usb id (philips 
luckily uses its own id's instead of generic id's). So I think in cases were we 
can tell it at the kernel level we should set a flag somewhere (and I believe 
the flags field of the v4l2_fmtdesc is the best place) to share this knowledge 
with userspace.

Then for laptops we will need a detection mechanism probably based on DMI 
strings (I feel hal is going to play a role here) and then check for flipx and 
y v4l2_ctrl's and if those are not present use software flipping (which I'm 
going to implement today for my philips cam).

Hmm, thinking more about the laptop problem, ideally hal would just do the 
v4l-ctrl calls itself, so that this happens only once (on plugin) and users can 
later override this. And then we would need some kinda hal boolean which libv4l 
can query called something like "needs software flip" for the other cases.

Regards,

Hans


p.s.

If someone can ship me a laptop which an upside down mounted cam I'll happily 
work on this issue :)

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
