Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:44506 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758578AbdKQOxA (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Fri, 17 Nov 2017 09:53:00 -0500
Received: by mail-wr0-f193.google.com with SMTP id l22so2321155wrc.11
        for <linux-media@vger.kernel.org>; Fri, 17 Nov 2017 06:52:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171117141826.GC17880@kroah.com>
References: <20171117141826.GC17880@kroah.com>
From: Philippe Ombredanne <pombredanne@nexb.com>
Date: Fri, 17 Nov 2017 15:52:18 +0100
Message-ID: <CAOFm3uGJS7Qno_xtnPNd3TpcuGXbXYj-mMenBhZKp6cXTFqDxw@mail.gmail.com>
Subject: Re: [PATCH] media: usbvision: remove unneeded DRIVER_LICENSE #define
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Fri, Nov 17, 2017 at 3:18 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> There is no need to #define the license of the driver, just put it in
> the MODULE_LICENSE() line directly as a text string.
>
> This allows tools that check that the module license matches the source
> code license to work properly, as there is no need to unwind the
> unneeded dereference.
>
> Cc: Hans Verkuil <hverkuil@xs4all.nl>
> Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
> Cc: Johan Hovold <johan@kernel.org>
> Cc: Davidlohr Bueso <dave@stgolabs.net>
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Reported-by: Philippe Ombredanne <pombredanne@nexb.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>


Reviewed-by: Philippe Ombredanne <pombredanne@nexb.com>
-- 
Cordially
Philippe Ombredanne
