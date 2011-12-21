Return-path: <linux-media-owner@vger.kernel.org>
Received: from perceval.ideasonboard.com ([95.142.166.194]:41848 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab1LUAeo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 20 Dec 2011 19:34:44 -0500
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: "Zhu, Mingcheng" <mingchen@quicinc.com>
Subject: Re: query video dev node name using the V4L2 device driver name
Date: Wed, 21 Dec 2011 01:34:43 +0100
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
References: <20111215095015.GC3677@valkosipuli.localdomain> <201112191131.23195.laurent.pinchart@ideasonboard.com> <3D233F78EE854A4BA3D34C11AD4FAC1FDEF79C@nasanexd01b.na.qualcomm.com>
In-Reply-To: <3D233F78EE854A4BA3D34C11AD4FAC1FDEF79C@nasanexd01b.na.qualcomm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201112210134.43822.laurent.pinchart@ideasonboard.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Mingcheng,

On Monday 19 December 2011 19:09:18 Zhu, Mingcheng wrote:
> Hi Laurent,
> 
> I have a problem here. Take following example that we have two video dev
> nodes as:
> /dev/video0: this node is for WIFI capture

WIFI capture ? I'm curious about that, what do you mean exactly ?

> /dev/video1: this is the camera driver.
> 
> Is it possible for the user space to find out video1 is the camera without
> open and query each video node's capabilities?

If the drivers that expose those nodes are media-controller aware, one 
possible solution is to open the media controller device(s) and enumerate the 
entities. I'm not sure that would be faster than opening and querying the 
video nodes though.

-- 
Regards,

Laurent Pinchart
