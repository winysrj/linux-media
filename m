Return-path: <mchehab@pedra>
Received: from perceval.ideasonboard.com ([95.142.166.194]:60887 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753179Ab1CaOLs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Thu, 31 Mar 2011 10:11:48 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: riverful.kim@samsung.com
Subject: Re: [RFC] API for controlling Scenemode Preset
Date: Thu, 31 Mar 2011 16:12:09 +0200
Cc: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	"kyungmin.park@samsung.com" <kyungmin.park@samsung.com>
References: <4D94137D.9020309@samsung.com>
In-Reply-To: <4D94137D.9020309@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201103311612.10234.laurent.pinchart@ideasonboard.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Hi HeungJun,

On Thursday 31 March 2011 07:39:09 Kim, HeungJun wrote:
> Hello everyone,
> 
> This is a suggestion about the preset for the scenemode of camera. It's
> just one API, and its role determines which current scenemode preset of
> camera is.
> 
> The kinds of scenemode are various at each camera. But, as you look around
> camera, the each scenemode has common name and the specific scenemode just
> exist or not. So, I started to collect the scenemode common set of Fujitsu
> M-5MOLS and NEC CE147. And, I found these modes are perfetly matched,
> althogh the names are a little different.

[snip]

Are those presets really implemented in hardware ? I expect that they control 
various configuration parameters such as white balance. Can all those 
parameters also be controlled manually, or are they (or some of them) settable 
only through the scene mode presets ?

-- 
Regards,

Laurent Pinchart
