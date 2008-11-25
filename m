Return-path: <video4linux-list-bounces@redhat.com>
Received: from mx3.redhat.com (mx3.redhat.com [172.16.48.32])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id mAP8Oo8m015898
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 03:24:50 -0500
Received: from smtp-vbr9.xs4all.nl (smtp-vbr9.xs4all.nl [194.109.24.29])
	by mx3.redhat.com (8.13.8/8.13.8) with ESMTP id mAP8OcbR005357
	for <video4linux-list@redhat.com>; Tue, 25 Nov 2008 03:24:38 -0500
Message-ID: <17655.62.70.2.252.1227601475.squirrel@webmail.xs4all.nl>
Date: Tue, 25 Nov 2008 09:24:35 +0100 (CET)
From: "Hans Verkuil" <hverkuil@xs4all.nl>
To: "Trilok Soni" <soni.trilok@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: v4l <video4linux-list@redhat.com>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	"davinci-linux-open-source@linux.davincidsp.com"
	<davinci-linux-open-source@linux.davincidsp.com>,
	linux-kernel@vger.kernel.org
Subject: Re: v4l2_device/v4l2_subdev: please review
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

> Hi Hans,
>
>>
>> I'm not going to spam the list with these quite big patches. Just go to
>> http://linuxtv.org/hg/~hverkuil/v4l-dvb-ng/ and click on the 'raw' link
>> after each change to see the patch. Most of these changes are just
>> boring i2c driver conversions.
>
> It is hard to review these patches from this link, as if you submit
> the patch to ML then someone can just give inline comments to your
> patch, otherwise reviewer has to copy that code which he/she wants to
> comment while replying and not easy to track too. I don't know size
> limit of this v4l2 ML, but linux-kernel ML can receive somewhat big
> patches I believe.

The V4L2 ML is fairly limited. I'm pretty sure it can't handle the ivtv
change (70+ kB). I can do this for the two changes that actually add the
new code and for one of the i2c conversion tonight (this webmail client
messes up the layout).

Personally I dislike reviewing large patches that are part of an email.
Smaller ones are OK, but large patches are hard to read. Much easier to
review with a decent editor.

>
>>
>> We are adding to the v4l core, but the changes do not affect existing
>> v4l drivers let alone other subsystems. Although I should probably have
>> added the omap list.
>
> OMAP + soc-camera + v4l2-int-* community would be more interested to
> see these patches as they need to change their sensor/controller
> drivers to adapt your changes.

I'll add the linux-omap mailinglist when I repost tonight.

Regards,

          Hans

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
