Return-path: <linux-media-owner@vger.kernel.org>
Received: from ec2-52-27-115-49.us-west-2.compute.amazonaws.com ([52.27.115.49]:46440
	"EHLO s-opensource.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843AbcGMLoB (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 13 Jul 2016 07:44:01 -0400
Date: Wed, 13 Jul 2016 08:43:16 -0300
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
	Mauro Carvalho Chehab <mchehab@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] [media] docs-rst: escape [] characters
Message-ID: <20160713084316.355f5be2@recife.lan>
In-Reply-To: <ffbab694ede33c294e5864a5e0bf4d1474446a71.1468408280.git.mchehab@s-opensource.com>
References: <4855307b81f02af4853e02cba2ce16eb29376548.1468408280.git.mchehab@s-opensource.com>
	<ffbab694ede33c294e5864a5e0bf4d1474446a71.1468408280.git.mchehab@s-opensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Em Wed, 13 Jul 2016 08:15:48 -0300
Mauro Carvalho Chehab <mchehab@s-opensource.com> escreveu:

> Those characters are used for citations. Better to escape, to
> avoid them to be misinterpreted.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
> ---

> diff --git a/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf b/Documentation/media/uapi/v4l/dev-raw-vbi_files/vbi_625.pdf
> index 765235e33a4de256a0b3fbf64ffe52946190cac4..f672b52ef683b3b6da4a43167f67ecbecfd6dc36 100644
> GIT binary patch
> delta 18
> ZcmaDX^HgR-AtP%{w54Ut<`TyDJOD)g2G9Ti
> 
> delta 16
> XcmaDV^H^p>AtQ6NrRC-_#`in`I2#5S  
> 

This is clearly wrong. I'm nacking my own patch ;)


Thanks,
Mauro
