Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp0.lie-comtel.li ([217.173.238.80]:60230 "EHLO
	smtp0.lie-comtel.li" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164AbZBQTpA (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Feb 2009 14:45:00 -0500
Received: from localhost (localhost.lie-comtel.li [127.0.0.1])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id 507029FEC1E
	for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 20:35:31 +0100 (GMT-1)
Received: from [192.168.0.16] (217-173-228-198.cmts.powersurf.li [217.173.228.198])
	by smtp0.lie-comtel.li (Postfix) with ESMTP id 7D8289FEC1D
	for <linux-media@vger.kernel.org>; Tue, 17 Feb 2009 20:35:30 +0100 (GMT-1)
Message-ID: <499B1180.6020600@kaiser-linux.li>
Date: Tue, 17 Feb 2009 20:35:28 +0100
From: Thomas Kaiser <v4l@kaiser-linux.li>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
Subject: Re: MR97310A and other image formats
References: <20090217200928.1ae74819@free.fr>
In-Reply-To: <20090217200928.1ae74819@free.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Jean-Francois Moine wrote:
> Hi Kyle,
> 
> Looking at the v4l library from Hans de Goede, I did not find the
> decoding of the MR97310A images. May you send him a patch for that?
> 
> BTW, I am coding the subdriver of a new webcam, and I could not find
> how to decompress the images. It tried many decompression functions,
> those from the v4l library and most from libgphoto2 without any
> success. Does anyone know how to find the compression algorithm?
> 
> Cheers.
> 

Hello Jean-Francois

Do you have some more information about the cam and the stream?
Do you know the frame header?
Any idea what the compression should be?
Can you provide a raw stream from the cam?

Thomas
