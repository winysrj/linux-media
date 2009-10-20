Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qy0-f194.google.com ([209.85.221.194]:56827 "EHLO
	mail-qy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbZJTSfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Oct 2009 14:35:45 -0400
Received: by qyk32 with SMTP id 32so4265402qyk.4
        for <linux-media@vger.kernel.org>; Tue, 20 Oct 2009 11:35:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <2df568dc0910200911w301da2cbyb7ba8726d2f0c94a@mail.gmail.com>
References: <2df568dc0910200911w301da2cbyb7ba8726d2f0c94a@mail.gmail.com>
Date: Tue, 20 Oct 2009 12:35:48 -0600
Message-ID: <2df568dc0910201135u25eee08aq25ea4e8865b10ba9@mail.gmail.com>
Subject: Re: saa7134-empress output format problem
From: Gordon Smith <spider.karma+linux-media@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tue, Oct 20, 2009 at 10:11 AM, Gordon Smith
<spider.karma+linux-media@gmail.com> wrote:
> Hello -
>
> I have a saa7134 video encoder card "RTD Embedded Technologies VFG73"
> in 2.6.28.9 with recent v4l2 (3919b17dc88e). It has two compression
> channels and no tuner.
>

I can clarify that my card is "RTD Embedded Technologies VFG7350".

> # v4l2-ctl --device /dev/video3 --all
> Driver Info:
>      Driver name   : saa7134
>      Card type     : RTD Embedded Technologies VFG73
>      Bus info      : PCI:0000:02:09.0
>      Driver version: 527
>      Capabilities  : 0x05000015
>              Video Capture
>              Video Overlay
>              VBI Capture
>              Read/Write
>              Streaming
