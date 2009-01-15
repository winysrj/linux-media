Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:35544 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255AbZAOMAV (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Thu, 15 Jan 2009 07:00:21 -0500
Date: Thu, 15 Jan 2009 12:49:46 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Guinn <elyk03@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: Re: [PATCH 1/2] Add Mars-Semi MR97310A format
Message-ID: <20090115124946.52779651@free.fr>
In-Reply-To: <200901142059.34943.elyk03@gmail.com>
References: <200901142059.34943.elyk03@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wed, 14 Jan 2009 20:59:34 -0600
Kyle Guinn <elyk03@gmail.com> wrote:

> Add a pixel format for the Mars-Semi MR97310A webcam controller.
> 
> The MR97310A is a dual-mode webcam controller that provides
> compressed BGGR Bayer frames.  The decompression algorithm for still
> images is the same as for video, and is currently implemented in
> libgphoto2.

Hi Kyle,

What is the difference of this pixel format from the other Bayer ones?

Also, did you ask Hans de Goede to add the decoding to the v4l library?

Regards.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
