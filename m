Return-path: <linux-media-owner@vger.kernel.org>
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:40438 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752068Ab2BWRd1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 23 Feb 2012 12:33:27 -0500
Received: by mail-qw0-f48.google.com with SMTP id h8so1925007qau.14
        for <linux-media@vger.kernel.org>; Thu, 23 Feb 2012 09:33:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH9_wRN5=nHtB9M3dL4wvZGL3+mb4_TfS=uPun_13D7n0E3CKA@mail.gmail.com>
References: <CAH9_wRN5=nHtB9M3dL4wvZGL3+mb4_TfS=uPun_13D7n0E3CKA@mail.gmail.com>
From: "Aguirre, Sergio" <saaguirre@ti.com>
Date: Thu, 23 Feb 2012 11:33:06 -0600
Message-ID: <CAKnK67T=obVTWkzZqVtv+PninjkbLp1os5AnsoZ+j=NGFFMWLA@mail.gmail.com>
Subject: Re: Video Capture Issue
To: Sriram V <vshrirama@gmail.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Sriram,

On Thu, Feb 23, 2012 at 11:25 AM, Sriram V <vshrirama@gmail.com> wrote:
> Hi,
>  1) I am trying to get a HDMI to CSI Bridge chip working with OMAP4 ISS.
>      The issue is the captured frames are completely green in color.

Sounds like the buffer is all zeroes, can you confirm?

>  2) The Chip is configured to output VGA Color bar sequence with
> YUV422-8Bit and
>       uses datalane 0 only.
>  3) The Format on OMAP4 ISS  is UYVY (Register 0x52001074 = 0x0A00001E)
>  I am trying to directly dump the data into memory without ISP processing.
>
>
>  Please advice.

Just to be clear on your environment, which branch/commitID are you based on?

Regards,
Sergio

>
> --
> Regards,
> Sriram
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
