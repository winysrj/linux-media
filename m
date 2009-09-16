Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:45806 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754258AbZIPTFu (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 16 Sep 2009 15:05:50 -0400
Received: by fxm17 with SMTP id 17so2509390fxm.37
        for <linux-media@vger.kernel.org>; Wed, 16 Sep 2009 12:05:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1253120892.3669.11.camel@paulo-desktop>
References: <1253120892.3669.11.camel@paulo-desktop>
Date: Wed, 16 Sep 2009 15:05:52 -0400
Message-ID: <30353c3d0909161205v33883fcawc048f5bad49d3f90@mail.gmail.com>
Subject: Re: Create a /dev/video0 file and write directly into it images
From: David Ellingsworth <david@identd.dyndns.org>
To: Paulo Freitas <paulojlfreitas@sapo.pt>
Cc: video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, Sep 16, 2009 at 1:08 PM, Paulo Freitas <paulojlfreitas@sapo.pt> wrote:
> Hi everyone,
>
> I have an Ethernet Camera, from Prosilica, and I need to somehow emulate
> this camera in a /dev/video0 file. My idea is, mount a driver file using
> 'makedev', pick up images from the camera and write them into
> the /dev/video0 file. You know how V4L can be used to write images
> in /dev/video files? I don't know if it is needed to use makedev
> probably not. Any suggestion is welcome.
>
> Thank you for your help.
> Best regards, Paulo Freitas.

Sounds to me like you need a loop back video driver which is capable
of being fed data from a user space application. I don't know if this
patch was ever applied http://patchwork.kernel.org/patch/24370/ but it
seems like something you might be able to use to achieve what you want
to do.

Regards,

David Ellingsworth

P.S. In the future, please post questions to the new mailing list:
linux-media@vger.kernel.org
