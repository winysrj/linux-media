Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mBA9qOrm004733
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 04:52:24 -0500
Received: from ey-out-2122.google.com (ey-out-2122.google.com [74.125.78.24])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mBA9qBgp000545
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 04:52:11 -0500
Received: by ey-out-2122.google.com with SMTP id 4so60537eyf.39
	for <video4linux-list@redhat.com>; Wed, 10 Dec 2008 01:52:10 -0800 (PST)
Message-ID: <de8cad4d0812100152w4636cf83rd0dc4997d80125ea@mail.gmail.com>
Date: Wed, 10 Dec 2008 04:52:10 -0500
From: "Brandon Jenkins" <bcjenkins@tvwhere.com>
To: "Hans Verkuil" <hverkuil@xs4all.nl>
In-Reply-To: <200812092232.52716.hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_103644_13280640.1228902730369"
References: <15114.62.70.2.252.1228832086.squirrel@webmail.xs4all.nl>
	<200812091918.00276.hverkuil@xs4all.nl>
	<de8cad4d0812091318h348d4417lef4e98dc9593445e@mail.gmail.com>
	<200812092232.52716.hverkuil@xs4all.nl>
Cc: video4linux-list@redhat.com
Subject: Re: v4l2-compat-ioctl32 update?
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

------=_Part_103644_13280640.1228902730369
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi Hans,

I have patched the module, rebooted and ran a script to query
dev/video (HVR-1600) for all of the get and list controls in the help
output.

I am attaching the output of that, the dmesg output, and dmesg output
while running captures using SageTV. I will work on a script to
execute the set commands. Please let me know if I can be doing this
better.

Regards,

Brandon

On Tue, Dec 9, 2008 at 4:32 PM, Hans Verkuil <hverkuil@xs4all.nl> wrote:
> On Tuesday 09 December 2008 22:18:28 Brandon Jenkins wrote:
>> Hi Hans,
>>
>> Received the following during compilation:
>>
>> CC [M]  /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.o
>> /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c: In function
>> 'put_v4l2_ext_controls32':
>> /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c:615: error: 'kcontrols'
>> undeclared (first use in this function)
>> /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c:615: error: (Each
>> undeclared identifier is reported only once
>> /root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.c:615: error: for each
>> function it appears in.)
>> make[3]: *** [/root/drivers/hdpvr/v4l/v4l2-compat-ioctl32.o] Error 1
>> make[2]: *** [_module_/root/drivers/hdpvr/v4l] Error 2
>> make[2]: Leaving directory `/usr/src/linux-2.6.27-ARCH'
>> make[1]: *** [default] Error 2
>> make[1]: Leaving directory `/root/drivers/hdpvr/v4l'
>> make: *** [all] Error 2
>
> Hmm, note to self: must compile this on a 64-bit CPU :-)
>
> Try the attached patch, this time it should compile.
>
>        Hans
>
>>
>> Brandon
>>
>> On Tue, Dec 9, 2008 at 1:18 PM, Hans Verkuil <hverkuil@xs4all.nl>
> wrote:
>> > On Tuesday 09 December 2008 15:14:46 Hans Verkuil wrote:
>> >> OK, I'll mail you a diff this evening. In the meantime, can you
>> >> compile v4l2-ctl for 32-bit? That's the test tool for several of
>> >> my tests.
>> >
>> > Hi Brandon,
>> >
>> > As promised I've attached the diff with my current changes.
>> >
>> > You should be able to test it fairly well with v4l2-ctl. In
>> > particular, please test getting and setting controls (MPEG controls
>> > use S_EXT_CTRLS while user controls use the older VIDIOC_S_CTRL
>> > ioctl).
>> >
>> > Also try --get-audio-input, --list-audio-inputs, --get-cropcap,
>> > --get-input, --set-input and --list-inputs.
>> >
>> > Basically test as many ioctls as you can :-) And of course with
>> > sagetv!
>> >
>> > Thanks,
>> >
>> >        Hans
>> >
>> >> Regards,
>> >>
>> >>        Hans
>> >>
>> >> > Hans,
>> >> >
>> >> > I would love to test! I am using 3 HVR-1600s and an HD-PVR for
>> >> > encoders.
>> >> >
>> >> > Brandon
>> >> >
>> >> > On Tue, Dec 9, 2008 at 9:03 AM, Hans Verkuil
>> >> > <hverkuil@xs4all.nl>
>> >
>> > wrote:
>> >> >> Hi Brandon,
>> >> >>
>> >> >> As you noticed I found suspicious code in the current source.
>> >> >> At the moment I have no easy way of testing this, although I
>> >> >> hope to be able to do that some time in the next week or the
>> >> >> week after that.
>> >> >>
>> >> >> However, if you are able to do some testing for me, then that
>> >> >> would be very welcome and definitely speed things up.
>> >> >>
>> >> >> I have a patch that I can mail you and a bunch of tests to
>> >> >> perform.
>> >> >>
>> >> >> Let me know if you can help.
>> >> >>
>> >> >> Regards,
>> >> >>
>> >> >>        Hans
>> >> >>
>> >> >>> Hi Hans,
>> >> >>>
>> >> >>> I noted over the weekend that you were working on updating the
>> >> >>> v4l2-compat-ioctl32 module, thank you! Do you have a sense of
>> >> >>> timing for availability in your tree? I know of a few SageTV
>> >> >>> users who will be glad to see it done. :)
>> >> >>>
>> >> >>> Thanks in advance,
>> >> >>>
>> >> >>> Brandon
>> >> >>
>> >> >> --
>> >> >> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>> >
>> > --
>> > Hans Verkuil - video4linux developer - sponsored by TANDBERG
>
>
>
> --
> Hans Verkuil - video4linux developer - sponsored by TANDBERG
>

------=_Part_103644_13280640.1228902730369
Content-Type: application/x-gzip; name=v4l2-ctl.log.gz
Content-Transfer-Encoding: base64
X-Attachment-Id: f_fojsy7c31
Content-Disposition: attachment; filename=v4l2-ctl.log.gz

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
K5bYxp3IuiWmqCBa4qv/qJ4ENf8B2PgKqjpiAAA=
------=_Part_103644_13280640.1228902730369
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
------=_Part_103644_13280640.1228902730369--
