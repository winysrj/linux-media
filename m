Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:61702 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658AbaLGUwo (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Sun, 7 Dec 2014 15:52:44 -0500
Received: by mail-ig0-f180.google.com with SMTP id h15so1831947igd.13
        for <linux-media@vger.kernel.org>; Sun, 07 Dec 2014 12:52:44 -0800 (PST)
Received: from sleipnir.lan (h173-209-125-8.mcsnet.ca. [173.209.125.8])
        by mx.google.com with ESMTPSA id j2sm2788164igj.14.2014.12.07.12.52.41
        for <linux-media@vger.kernel.org>
        (version=SSLv3 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Sun, 07 Dec 2014 12:52:42 -0800 (PST)
Date: Sun, 7 Dec 2014 13:52:37 -0700
From: HeavyJoost <heavyjoost@heavyjoost.ca>
To: linux-media@vger.kernel.org
Subject: [BUG] libdvbv5: dvb_fe_retrieve_quality not working correctly
 (dvb-fe.c)
Message-ID: <20141207135237.4ad61a94@sleipnir.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

I was trying out this library and I found two things that probably need fixing in dvb_fe_retrieve_quality. Without this it only returns DVB_QUAL_UNKNOWN for my setup.


Issue 1 on line 1205:

ber = dvb_fe_retrieve_per(&parms->p, layer);

As far as I can tell this should use dvb_fe_retrieve_ber (so _ber instead of _per) with the appropriate arguments.


Issue 2 on line 1218:

dvbv_fe_cnr_to_quality(parms, cnr);

This probably needs to be changed to the following because it doesn't have any effect otherwise ;)

qual = dvbv_fe_cnr_to_quality(parms, cnr);
