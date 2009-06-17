Return-path: <linux-media-owner@vger.kernel.org>
Received: from ppsw-0.csi.cam.ac.uk ([131.111.8.130]:34948 "EHLO
	ppsw-0.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249AbZFQNrT (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 17 Jun 2009 09:47:19 -0400
Message-ID: <4A38F40D.9060209@cam.ac.uk>
Date: Wed, 17 Jun 2009 13:47:57 +0000
From: Jonathan Cameron <jic23@cam.ac.uk>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: typo: v4l2_bound_align_image name mismatch.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Just came across a build error with pxa_camera with Mauro's linux-next tree.

pxa-camera calls v4l2_bound_align_image whereas the function is called
v4l_bound_align_image.  

Cheers,

---
Jonathan Cameron
