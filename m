Return-path: <linux-media-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:45214 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2F2IbY (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Fri, 29 Jun 2012 04:31:24 -0400
From: Ralph Metzler <rjkm@metzlerbros.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20461.26585.508583.521723@morden.metzler>
Date: Fri, 29 Jun 2012 10:31:21 +0200
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-media@vger.kernel.org
Subject: [PATCH 1/2] [media] drxk: Make the QAM demodulator command configurable.
In-Reply-To: <1340918440-17523-2-git-send-email-martin.blumenstingl@googlemail.com>
References: <1340918440-17523-1-git-send-email-martin.blumenstingl@googlemail.com>
	<1340918440-17523-2-git-send-email-martin.blumenstingl@googlemail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Martin Blumenstingl writes:
 > Currently there are two different commands: the old command which takes
 > 4 parameters, and a newer one with just takes 2 parameters.

Hi,

are you sure about this?
>From what I have been told, the 2 parameter command is in the 
firmware ROM and older loadable/patch firmwares.
Newer firmwares provided the 4 parameter command.

Regards,
Ralph

