Return-path: <linux-media-owner@vger.kernel.org>
Received: from static-72-93-233-3.bstnma.fios.verizon.net ([72.93.233.3]:40831
	"EHLO mail.wilsonet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722AbZKUSaK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sat, 21 Nov 2009 13:30:10 -0500
Subject: Re: ENE CIR driver
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Jarod Wilson <jarod@wilsonet.com>
In-Reply-To: <a728f9f90911210918p4b1a4e2ajb3a8032d99f0cb5b@mail.gmail.com>
Date: Sat, 21 Nov 2009 13:30:02 -0500
Cc: linux-media <linux-media@vger.kernel.org>,
	Maxim Levitsky <maximlevitsky@gmail.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <6B0271AF-79D7-4AB1-B6F7-AB5A553EE1B2@wilsonet.com>
References: <a728f9f90911210918p4b1a4e2ajb3a8032d99f0cb5b@mail.gmail.com>
To: Alex Deucher <alexdeucher@gmail.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Nov 21, 2009, at 12:18 PM, Alex Deucher wrote:

> Does anyone know if there is a driver or documentation available for
> the ENE CIR controller that's incorporated into many of their keyboard
> controllers?  If there is no driver but documentation, are there
> drivers for other CIR controllers that could be used as a reference?

Maxim Levitsky authored lirc_ene0100, which is in the lirc tarball and my lirc git tree now, with the intention of submitting it for upstream kernel inclusion once (if?) we get the base lirc bits accepted.

-- 
Jarod Wilson
jarod@wilsonet.com



