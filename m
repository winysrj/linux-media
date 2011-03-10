Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:53008 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab1CJLWI (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 10 Mar 2011 06:22:08 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: jtp.park@samsung.com
Subject: Re: [PATCH/RFC 0/2] Support controls at the subdev file handler level
Date: Thu, 10 Mar 2011 12:22:31 +0100
Cc: linux-media@vger.kernel.org
References: <1299706041-21589-1-git-send-email-laurent.pinchart@ideasonboard.com> <000601cbdf09$76be8c10$643ba430$%park@samsung.com>
In-Reply-To: <000601cbdf09$76be8c10$643ba430$%park@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="euc-kr"
Content-Transfer-Encoding: 7bit
Message-Id: <201103101222.32238.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi,

On Thursday 10 March 2011 10:56:40 Jeongtae Park wrote:
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

Per-buffer controls would likely be implemented as a meta-data plane. This 
definitely needs to be brainstormed.

-- 
Regards,

Laurent Pinchart
