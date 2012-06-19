Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.serverraum.org ([78.47.150.89]:52047 "EHLO
	mail.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881Ab2FSUFW (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 Jun 2012 16:05:22 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.serverraum.org (Postfix) with ESMTP id 18FC03F001
	for <linux-media@vger.kernel.org>; Tue, 19 Jun 2012 22:05:21 +0200 (CEST)
Received: from mail.serverraum.org ([127.0.0.1])
	by localhost (web.serverraum.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id PsmYdm1WPJGZ for <linux-media@vger.kernel.org>;
	Tue, 19 Jun 2012 22:05:20 +0200 (CEST)
Received: from mail-yw0-f46.google.com (mail-yw0-f46.google.com [209.85.213.46])
	(using TLSv1 with cipher RC4-SHA (128/128 bits))
	(No client certificate requested)
	by mail.serverraum.org (Postfix) with ESMTPSA id B7B283EFFD
	for <linux-media@vger.kernel.org>; Tue, 19 Jun 2012 22:05:20 +0200 (CEST)
Received: by yhmm54 with SMTP id m54so5176797yhm.19
        for <linux-media@vger.kernel.org>; Tue, 19 Jun 2012 13:05:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4704338.LhTThHjxGK@avalon>
References: <CADYPuQ4eoX-eZNPQE6S2DYQFA-z2UuBNdpUNz4UCVi6GJWHruw@mail.gmail.com>
	<4704338.LhTThHjxGK@avalon>
Date: Tue, 19 Jun 2012 22:05:19 +0200
Message-ID: <CADYPuQ4MwciAeomieArLcFrEXLvSP6A9HS8beOsK8yp+JNeT1Q@mail.gmail.com>
Subject: Re: uvcvideo issue with kernel 3.5-rc2 and 3
From: Philipp Dreimann <philipp@dreimann.net>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On 18 June 2012 12:41, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:
> This might be cause by a bug in the USB core or in the UVC driver. Would you
> be able to bisect the regression ?
Are you aware of any tool to bisect such issues using
kvm/virtualbox/..? I would like to bisect the issue but rebooting the
system needs to be avoided.

> Or, alternatively, test the v3.4 uvcvideo
> driver on v3.5-rc3 ? Or the other way around, test the latest v4l tree on v3.4
> (instructions regarding how to compile the v4l tree with a different kernel
> are available at
> http://linuxtv.org/wiki/index.php/How_to_Obtain,_Build_and_Install_V4L-
> DVB_Device_Drivers).
I compiled the 3.4 module with 3.5-rc3. The error is still the same
using usb2. I tried to connect the camera to an usb3 port and it
worked as it should. -- The issue seems to be related to usb2 then.

I'll inform the usb guys.

Regards,
 Philipp Dreimann
