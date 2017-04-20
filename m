Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-wr0-f182.google.com ([209.85.128.182]:34446 "EHLO
        mail-wr0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943308AbdDTLW4 (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Thu, 20 Apr 2017 07:22:56 -0400
Received: by mail-wr0-f182.google.com with SMTP id z109so33456375wrb.1
        for <linux-media@vger.kernel.org>; Thu, 20 Apr 2017 04:22:55 -0700 (PDT)
MIME-Version: 1.0
From: Paulo Assis <pj.assis@gmail.com>
Date: Thu, 20 Apr 2017 12:22:34 +0100
Message-ID: <CAPueXH6ZBpjwa8REXSuynPPDv=k83z49h8v_rd=crOtfggGpPw@mail.gmail.com>
Subject: Fwd: uvcvideo extension controls
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

---------- Forwarded message ----------
From: Paulo Assis <pj.assis@gmail.com>
Date: 2017-04-20 12:04 GMT+01:00
Subject: uvcvideo extension controls
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>, aUDIo
<djaudio101@gmail.com>


Laurent Hi,


I've just noticed that uvcvideo extension controls no longer work
properly, for instance for a logitech c930e I have the
'UVC_GUID_LOGITECH_PERIPHERAL':

VideoControl Interface Descriptor:
       bLength                28
       bDescriptorType        36
       bDescriptorSubtype      6 (EXTENSION_UNIT)
       bUnitID                11
       guidExtensionCode         {212de5ff-3080-2c4e-82d9-f587d00540bd}
       bNumControl             3
       bNrPins                 1
       baSourceID( 0)         10
       bControlSize            3
       bmControls( 0)       0x00
       bmControls( 1)       0x41
       bmControls( 2)       0x01
       iExtension              0


when I try to map or query the controls associated with this GUID
(like the LED control) I get a ENOENT error, the same applies for
other GUID, although some, like the h264 extension, will work just
fine:

VideoControl Interface Descriptor:
       bLength                27
       bDescriptorType        36
       bDescriptorSubtype      6 (EXTENSION_UNIT)
       bUnitID                12
       guidExtensionCode         {41769ea2-04de-e347-8b2b-f4341aff003b}
       bNumControl            11
       bNrPins                 1
       baSourceID( 0)          3
       bControlSize            2
       bmControls( 0)       0x07
       bmControls( 1)       0x7f
       iExtension              0

'uvcdynctrl --device=/dev/video1 --get_raw=12:1' returns without error:

query control size of : 46
query control flags of: 0x3
----

 These mappings were working just fine in previous kernels, did
something changed in the uvc extension control API, or do you think
this is just a bug in the driver?

Regards,
Paulo
