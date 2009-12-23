Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:47537 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbZLWWf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 23 Dec 2009 17:35:27 -0500
Received: by bwz27 with SMTP id 27so5039901bwz.21
        for <linux-media@vger.kernel.org>; Wed, 23 Dec 2009 14:35:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20091222200159.2568b4b9@tele>
References: <271292.72699.qm@web94706.mail.in2.yahoo.com>
	 <20091222200159.2568b4b9@tele>
Date: Wed, 23 Dec 2009 23:35:25 +0100
Message-ID: <68dded740912231435i29624a48jd6ba6ac1ab064fc4@mail.gmail.com>
Subject: Re: flicker/jumpy at the bottom of the video
From: Olivier Lorin <olorin75@gmail.com>
To: purushottam_r_s@yahoo.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

one of the sensors managed by the gspca_gl860 has some weird
resolutions : 800 x 598 and 1600 x 1198. To set these resolutions to
800 x 600 and 1600 x 1200 causes a flickering effect because of both
missing lines of data from the sensor. Thus a stupid question, does
the resolutions are these chip are well known ?

O. Lorin

2009/12/22, Jean-Francois Moine <moinejf@free.fr>:
> On Mon, 23 Nov 2009 15:00:09 +0530 (IST)
> Purushottam R S <purushottam_r_s@yahoo.com> wrote:
>
>> I am using latest gspca driver from dvb for camera driver. But I see
>> bottom of the video has flickering/jumping effect.
>>
>> I have "Zippys" web camera, which is from Z-Star.  I have loaded the
>> following drivers.
>> 1. gspca_zc3xx 44832 0 - Live 0xbf01f000
>> 2. gspca_main 23840 1 gspca_zc3xx, Live 0xbf014000
>> 3. videodev 36672 1 gspca_main, Live 0xbf006000
>> 4. v4l1_compat 14788 1 videodev, Live 0xbf000000
>>
>> But otherwise there is no issue with video.
>
> Hello Purush,
>
> Sorry for the delay. We know that some webcams with Z-Star chips have
> such a problem, but it is a hardware problem and we did not find yet a
> way to fix it correctly...
>
> Best regards.
>
> --
> Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
> Jef		|		http://moinejf.free.fr/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
