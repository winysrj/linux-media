Return-path: <linux-media-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:6982 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757874AbZKACZH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 31 Oct 2009 22:25:07 -0400
Received: by qw-out-2122.google.com with SMTP id 9so935102qwb.37
        for <linux-media@vger.kernel.org>; Sat, 31 Oct 2009 19:25:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1257036094.3181.7.camel@palomino.walls.org>
References: <1257020204.3087.18.camel@palomino.walls.org>
	 <829197380910311328u2879c45ep2023a99058112549@mail.gmail.com>
	 <1257036094.3181.7.camel@palomino.walls.org>
Date: Sat, 31 Oct 2009 22:25:12 -0400
Message-ID: <de8cad4d0910311925u28895ca9q454ccf0ac1032302@mail.gmail.com>
Subject: Re: cx18: YUV frame alignment improvements
From: Brandon Jenkins <bcjenkins@tvwhere.com>
To: Andy Walls <awalls@radix.net>
Cc: Devin Heitmueller <dheitmueller@kernellabs.com>,
	linux-media@vger.kernel.org, ivtv-devel@ivtvdriver.org,
	Simon Farnsworth <simon.farnsworth@onelan.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Sat, Oct 31, 2009 at 8:41 PM, Andy Walls <awalls@radix.net> wrote:
> On Sat, 2009-10-31 at 16:28 -0400, Devin Heitmueller wrote:
>> On Sat, Oct 31, 2009 at 4:16 PM, Andy Walls <awalls@radix.net> wrote:
>
>>
>> Hi Andy,
>>
>> How does this code work if the cx23418 scaler is used (resulting in
>> the size of the frames to be non-constant)?  Or is the scaler not
>> currently supported in the driver?
>
> I also forgot to mention, changing size while the encoder has an analog
> stream running (MPEG, VBI, YUV, IDX) is not permitted by the firmware.
> So this change works just fine as it computes the buffer size to use
> just as it sets up to start the capture.
>
> Regards,
> Andy
>
>>
>> Devin
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi Andy,

I tried to pull your changes and received an error on a missing .hg.
Subsequently, I downloaded the bz2 file and upon reboot I received a
kernel panic due to DMA issues.

Brandon
