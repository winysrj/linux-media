Return-path: <linux-media-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:53050 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab0CALXf (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Mon, 1 Mar 2010 06:23:35 -0500
Date: Mon, 1 Mar 2010 12:23:26 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firedtv: add parameter to fake ca_system_ids in CA_INFO
To: linux-media@vger.kernel.org, Henrik Kurelid <henrik@kurelid.se>
cc: Mauro Carvalho Chehab <mchehab@infradead.org>
In-Reply-To: <tkrat.a8cdf995cdc06e83@s5r6.in-berlin.de>
Message-ID: <tkrat.0c0bd27e15a3e108@s5r6.in-berlin.de>
References: <tkrat.dc97d52c76a2dc07@s5r6.in-berlin.de>
 <tkrat.a8cdf995cdc06e83@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

> The Digital Everywhere firmware have the shortcoming that ca_info_enq and
> ca_info are not supported. This means that we can never retrieve the correct
> ca_system_id to present in the CI message CA_INFO. Currently the driver uses
> the application id retrieved using app_info_req and app_info, but this id
> only match the correct ca_system_id as given in ca_info in some cases.
> This patch adds a parameter to the driver in order for the user to override
> what will be returned in the CA_INFO CI message. Up to four ca_system_ids can
> be specified.
> This is needed for users with CAMs that have different manufacturer id and
> ca_system_id and that uses applications that take this into account, like
> MythTV.

This workaround is of course rather awkward.  Users who need this will
have a hard time to work out that this parameter needs to be set and
how.  Furthermore, the web site of Digital Everywhere says that hey
stopped manufacturing and ramped down support, hence it looks like this
issue will stay with us forever.

Isn't there a CA command that could be (mis)used for some kind of
probing of the CAM for correct system IDs?  E.g. a loop which retries a
kind of dummy operation with different system IDs until success,
initially during fdtv_dvb_register/ fdtv_ca_register?

(I don't know how CI works, and alas I don't have a CAM myself for
testing and am not very keen on getting one...)
-- 
Stefan Richter
-=====-==-=- --== ----=
http://arcgraph.de/sr/

