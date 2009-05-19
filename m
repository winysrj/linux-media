Return-path: <linux-media-owner@vger.kernel.org>
Received: from banach.math.auburn.edu ([131.204.45.3]:40171 "EHLO
	banach.math.auburn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbZESUVs (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 19 May 2009 16:21:48 -0400
Date: Tue, 19 May 2009 15:35:50 -0500 (CDT)
From: Theodore Kilgore <kilgota@banach.math.auburn.edu>
To: Hans de Goede <j.w.r.degoede@hhs.nl>
cc: linux-media@vger.kernel.org
Subject: What is libv4lconvert/sn9c202x.c for?
In-Reply-To: <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu>
Message-ID: <alpine.LNX.2.00.0905191529260.19936@banach.math.auburn.edu>
References: <1242316804.1759.1@lhost.ldomain> <4A0C544F.1030801@hhs.nl> <alpine.LNX.2.00.0905141424460.11396@banach.math.auburn.edu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>


I can not seem to be able to find any such devices which use this. So 
perhaps I am not looking in the right place and someone could point me 
there.

In any event, it appears to me to have absolutely nothing at all to do 
with the decompression algorithm required by the SN9C2028 cameras. Those 
require a differential Huffman encoding scheme similar to what is in use 
for the MR97310a cameras, but with a few crucial differencew which make it 
pretty much impossible to write one routine for both. But the code in the 
file libv4lconvert/sn9c202x.c appears to me to be no differential Huffman 
scheme at all but something entirely different.

Hence my question.

Theodore Kilgore

