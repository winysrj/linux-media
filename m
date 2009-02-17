Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:57921 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643AbZBQTKs (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 14:10:48 -0500
Date: Tue, 17 Feb 2009 20:09:28 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Kyle Guinn <elyk03@gmail.com>
Cc: linux-media@vger.kernel.org
Subject: MR97310A and other image formats
Message-ID: <20090217200928.1ae74819@free.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi Kyle,

Looking at the v4l library from Hans de Goede, I did not find the
decoding of the MR97310A images. May you send him a patch for that?

BTW, I am coding the subdriver of a new webcam, and I could not find
how to decompress the images. It tried many decompression functions,
those from the v4l library and most from libgphoto2 without any
success. Does anyone know how to find the compression algorithm?

Cheers.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
