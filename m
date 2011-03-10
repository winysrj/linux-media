Return-path: <mchehab@pedra>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65134 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab1CJTnp (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 14:43:45 -0500
Received: by wwa36 with SMTP id 36so2358989wwa.1
        for <linux-media@vger.kernel.org>; Thu, 10 Mar 2011 11:43:44 -0800 (PST)
Message-ID: <4D7929EC.7080003@gmail.com>
Date: Thu, 10 Mar 2011 20:43:40 +0100
From: Sylwester Nawrocki <snjw23@gmail.com>
MIME-Version: 1.0
To: jtp.park@samsung.com
CC: linux-media@vger.kernel.org, laurent.pinchart@ideasonboard.com
Subject: Re: [PATCH/RFC 0/2] Support controls at the subdev file handler level
References: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com> <000601cbdf09$76be8c10$643ba430$%park@samsung.com>
In-Reply-To: <000601cbdf09$76be8c10$643ba430$%park@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On 03/10/2011 10:56 AM, Jeongtae Park wrote:
> Hi, all.
> 
> Some hardware need to handle per-filehandle level controls.
> Hans suggests add a v4l2_ctrl_handler struct v4l2_fh. It will be work fine.
> Although below patch series are for subdev, but it's great start point.
> I will try to make a patch.
> 
> If v4l2 control framework can be handle per-filehandle controls,
> a driver could be handle per-buffer level controls also. (with VB2 callback
> operation)
> 

Can you elaborate to what kind of per buffer controls are you referring to?
Using optional meta data planes is expected to be a proper way to do such
things. Either to pass meta data from application to driver or in the opposite
direction.

I can't see how the per buffer controls can be dependent on a per file handle
control support. Perhaps this is only specific to some selected devices.

--
Regards,
Sylwester Nawrocki

