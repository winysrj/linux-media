Return-path: <linux-media-owner@vger.kernel.org>
Received: from bay0-omc2-s27.bay0.hotmail.com ([65.54.190.102]:6537 "EHLO
	bay0-omc2-s27.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754523AbaDGLqP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 7 Apr 2014 07:46:15 -0400
Message-ID: <BAY176-W17F71D88B32603057AE378A9680@phx.gbl>
From: Divneil Wadhawan <divneil@outlook.com>
To: Hans Verkuil <hverkuil@xs4all.nl>, Pawel Osciak <pawel@osciak.com>
CC: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: RE: videobuf2-vmalloc suspect for corrupted data
Date: Mon, 7 Apr 2014 17:16:15 +0530
In-Reply-To: <BAY176-W91C143782DF21AB7ACEC8A9680@phx.gbl>
References: <BAY176-W225B62F958527124202669A9680@phx.gbl>,<CAMm-=zDKUoFN7OiGpL3c=7KCkmYNhiyns20t8H7Pz_=qgaeHMw@mail.gmail.com>,<BAY176-W524A762315BE245FCCD5DCA9680@phx.gbl>,<53428483.7060107@xs4all.nl>,<BAY176-W91C143782DF21AB7ACEC8A9680@phx.gbl>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> Which capture driver are you using?
> It's a TSMUX driver, written locally.
In complete, it's a Multi-INPUT, single output (MUXER) driver, but, currently, it's the capture side fault here.
Regards,
Divneil 		 	   		  