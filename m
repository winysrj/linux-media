Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp-vbr1.xs4all.nl ([194.109.24.21]:3652 "EHLO
	smtp-vbr1.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1IFLUh (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 6 Sep 2011 07:20:37 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Sakari Ailus <sakari.ailus@iki.fi>
Subject: Re: [RFC/PATCH 0/1] Ignore ctrl_class
Date: Tue, 6 Sep 2011 13:20:26 +0200
Cc: linux-media@vger.kernel.org
References: <20110906110742.GE1393@valkosipuli.localdomain>
In-Reply-To: <20110906110742.GE1393@valkosipuli.localdomain>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109061320.27093.hverkuil@xs4all.nl>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Tuesday, September 06, 2011 13:07:42 Sakari Ailus wrote:
> Hi,
> 
> I remember being in a discussion a while ago regarding the requirement of
> having all the controls belonging to the same class in
> VIDIOC_{TRY,S,G}_EXT_CTRLS. The answer I remember was that there was a
> historical reason for this and it no longer exists.

The original rule was that all controls have to belong to the same class. This was
done to simplify drivers. Drivers that use the control framework can handle a class
of 0, which means that the controls can be of any class.

But we still have drivers that implement S_EXT_CTRLS but do not use the control
framework, and for those this restriction is still valid. Usually such drivers will only
handle MPEG class controls through that API.

So I don't think this restriction can be lifted as long as there are drivers that do not
use the control framework.

Regards,

	Hans

> So here's the patch.
> 
> The changes in drivers were really simple but have not been tested. The
> changes in the control framework have been tested for querying, getting and
> setting extended and non-extended controls.
> 
> 
