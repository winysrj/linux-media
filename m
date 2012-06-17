Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.serverraum.org ([78.47.150.89]:55881 "EHLO
	mail.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756694Ab2FQLmg (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 17 Jun 2012 07:42:36 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.serverraum.org (Postfix) with ESMTP id 4F1FF3F018
	for <linux-media@vger.kernel.org>; Sun, 17 Jun 2012 13:35:09 +0200 (CEST)
Received: from mail.serverraum.org ([127.0.0.1])
	by localhost (web.serverraum.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id RqB7L7XyWQ07 for <linux-media@vger.kernel.org>;
	Sun, 17 Jun 2012 13:35:09 +0200 (CEST)
Received: from mail-ob0-f174.google.com (mail-ob0-f174.google.com [209.85.214.174])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by mail.serverraum.org (Postfix) with ESMTPSA id DE9AC3F01B
	for <linux-media@vger.kernel.org>; Sun, 17 Jun 2012 13:35:08 +0200 (CEST)
Received: by obbtb18 with SMTP id tb18so6868138obb.19
        for <linux-media@vger.kernel.org>; Sun, 17 Jun 2012 04:35:07 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 17 Jun 2012 13:35:07 +0200
Message-ID: <CADYPuQ4eoX-eZNPQE6S2DYQFA-z2UuBNdpUNz4UCVi6GJWHruw@mail.gmail.com>
Subject: uvcvideo issue with kernel 3.5-rc2 and 3
From: Philipp Dreimann <philipp@dreimann.net>
To: laurent.pinchart@ideasonboard.com, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

my external webcam from Logitech (I guess it's a c910) stopped working
using kernel 3.5-rc3.( 3.4 worked fine.)

uvcvideo: Found UVC 1.00 device <unnamed> (046d:0821)
input: UVC Camera (046d:0821) as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.2/1-1.2:1.2/input/input14
usbcore: registered new interface driver uvcvideo
USB Video Class driver (1.1.1)
uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 2: -71 (exp. 2).
uvcvideo: Failed to query (GET_DEF) UVC control 2 on unit 2: -71 (exp. 2).
uvcvideo: Failed to query (GET_DEF) UVC control 3 on unit 2: -71 (exp. 2).
uvcvideo: Failed to query (GET_DEF) UVC control 7 on unit 2: -71 (exp. 2).
uvcvideo: Failed to query (GET_DEF) UVC control 11 on unit 2: -71 (exp. 1).
uvcvideo: Failed to query (GET_DEF) UVC control 4 on unit 2: -71 (exp. 2).
uvcvideo: Failed to query (GET_DEF) UVC control 5 on unit 2: -71 (exp. 1).
uvcvideo: Failed to query (GET_CUR) UVC control 11 on unit 2: -71 (exp. 1).
uvcvideo: Failed to query (GET_DEF) UVC control 8 on unit 2: -71 (exp. 2).
uvcvideo: Failed to query (GET_DEF) UVC control 1 on unit 2: -71 (exp. 2).
uvcvideo: Failed to set UVC probe control : -71 (exp. 26).
uvcvideo: Failed to set UVC probe control : -71 (exp. 26).
uvcvideo: Failed to set UVC probe control : -71 (exp. 26).
uvcvideo: Failed to set UVC probe control : -71 (exp. 26).
(the last line is being repeated...)

I used cheese to test the webcam. My other webcam is working fine:
uvcvideo: Found UVC 1.00 device Integrated Camera (04f2:b217)
input: Integrated Camera as
/devices/pci0000:00/0000:00:1a.0/usb1/1-1/1-1.6/1-1.6:1.0/input/input13

Thanks,
Philipp Dreimann
