Return-path: <linux-media-owner@vger.kernel.org>
Received: from mk-outboundfilter-1.mail.uk.tiscali.com ([212.74.114.37]:26492
	"EHLO mk-outboundfilter-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751246AbZC2WKZ (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 29 Mar 2009 18:10:25 -0400
From: Adam Baker <linux@baker-net.org.uk>
To: linux-media@vger.kernel.org, Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: [PATCH v2 0/4] Sensor orientation reporting
Date: Sun, 29 Mar 2009 23:09:31 +0100
Cc: kilgota@banach.math.auburn.edu, Hans Verkuil <hverkuil@xs4all.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200903292309.31267.linux@baker-net.org.uk>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

Based on the limited feedback from last time I'm assuming people are generally 
happy with this so I've updated according to Jean-Francois Moine's comments 
and added documentation. Again this features only the minimum changes in 
libv4l to make some use of the info. 
