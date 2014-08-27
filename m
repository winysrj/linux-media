Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-oi0-f43.google.com ([209.85.218.43]:47312 "EHLO
	mail-oi0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934744AbaH0QJd (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 27 Aug 2014 12:09:33 -0400
MIME-Version: 1.0
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Date: Wed, 27 Aug 2014 18:09:13 +0200
Message-ID: <CAPybu_0O2V5Rod3gW7iiTSXBtowf2L8moJ8MY9Drzw1UbzshZg@mail.gmail.com>
Subject: Status of g_webcam uvc-gadget
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Linux USB Mailing List <linux-usb@vger.kernel.org>,
	linux-media <linux-media@vger.kernel.org>, bhupesh.sharma@st.com,
	bhupesh.sharma@freescale.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello

Is somebody using/supporting g_webcam?

The only reference userland server is uvc-gadget from
http://git.ideasonboard.org/?p=uvc-gadget.git;a=summary ?

I have an industrial fpga camera that speaks v4l2, my plan is to
export it as an uvc camera via usb3380 as a debug interface.

Thanks!

-- 
Ricardo Ribalda
