Return-path: <mchehab@pedra>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59890 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754059Ab0I1KFM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 28 Sep 2010 06:05:12 -0400
Received: by wyb28 with SMTP id 28so4774697wyb.19
        for <linux-media@vger.kernel.org>; Tue, 28 Sep 2010 03:05:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <ADF13DA15EB3FE4FBA487CCC7BEFDF3604CAE3BABC@bssrvexch01.BS.local>
References: <ADF13DA15EB3FE4FBA487CCC7BEFDF3604CAE3BABC@bssrvexch01.BS.local>
Date: Tue, 28 Sep 2010 19:05:10 +0900
Message-ID: <AANLkTi=wMWjiY2eNR9wSkWxjKX6d_Awm4J1v57tUDB=s@mail.gmail.com>
Subject: Re: RFC: Introduction of M2M capability and buffer types
From: Kyungmin Park <kmpark@infradead.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	pawel@osciak.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Any comments?

On Tue, Sep 14, 2010 at 11:29 PM, Kamil Debski <k.debski@samsung.com> wrote:
> Hello,
>
> Mem2mem devices currently use V4L2_CAP_VIDEO_CAPTURE and V4L2_CAP_VIDEO_OUTPUT capabilities. One might expect that a capture device is a camera and an output device can display images. If I remember correct our discussion during the Helsinki v4l2 summit, Hans de Goede has pointed that such devices are listed in applications and can confuse users. The user expects a camera and he has to choose from a long list of devices.
>
> The solution to this would be the introduction of two new capability V4L2_CAP_VIDEO_M2M. Such devices would not be listed when user is expected to choose which webcam or TV tuner device to use.
>
> Another thing about m2m devices is the naming of buffers: V4L2_BUF_TYPE_VIDEO_CAPTURE means the destination buffer and V4L2_BUF_TYPE_VIDEO_OUTPUT means source. This indeed is confusing, so I think the introduction of two new buffer types is justified. I would recommend V4L2_BUF_TYPE_M2M_SOURCE and V4L2_BUF_TYPE_M2M_DESTINATION to clearly state what is the buffer's purpose.
>
> I would be grateful for your comments to this RFC.
>
> Best wishes,
> --
> Kamil Debski
> Linux Platform Group
> Samsung Poland R&D Center
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
