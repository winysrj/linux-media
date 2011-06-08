Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:10726 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754335Ab1FHBqF (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 21:46:05 -0400
Received: from int-mx02.intmail.prod.int.phx2.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p581k5s9001184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:05 -0400
Received: from pedra (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p581jncB007506
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 21:46:04 -0400
Date: Tue, 7 Jun 2011 22:45:37 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH 10/15] [media] DocBook/frontend.xml: Recomend the usage of
 the new API
Message-ID: <20110607224537.1d34d54a@pedra>
In-Reply-To: <cover.1307496835.git.mchehab@redhat.com>
References: <cover.1307496835.git.mchehab@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)@casper.infradead.org
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

The old way of setting delivery system parameters were to use
an union with specific per-system parameters. However, as newer
delivery systems required more data, the structure size weren't
enough to fit. So, recomend using the DVBS2API instead.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/Documentation/DocBook/media/dvb/frontend.xml b/Documentation/DocBook/media/dvb/frontend.xml
index b1f0123..086e62b 100644
--- a/Documentation/DocBook/media/dvb/frontend.xml
+++ b/Documentation/DocBook/media/dvb/frontend.xml
@@ -221,8 +221,20 @@ by</para>
 <section id="dvb-frontend-parameters">
 <title>frontend parameters</title>
 <para>The kind of parameters passed to the frontend device for tuning depend on
-the kind of hardware you are using. All kinds of parameters are combined as an
-union in the FrontendParameters structure:</para>
+the kind of hardware you are using.</para>
+<para>The struct <constant>dvb_frontend_parameters</constant> uses an
+union with specific per-system parameters. However, as newer delivery systems
+required more data, the structure size weren't enough to fit, and just
+extending its size would break the existing applications. So, those parameters
+were replaced by the usage of <link linkend="FE_GET_SET_PROPERTY">
+<constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> ioctl's. The
+new API is flexible enough to add new parameters to existing delivery systems,
+and to add newer delivery systems.</para>
+<para>So, newer applications should use <link linkend="FE_GET_SET_PROPERTY">
+<constant>FE_GET_PROPERTY/FE_SET_PROPERTY</constant></link> instead, in
+order to be able to support the newer System Delivery like  DVB-S2, DVB-T2,
+DVB-C2, ISDB, etc.</para>
+<para>All kinds of parameters are combined as an union in the FrontendParameters structure:</para>
 <programlisting>
 struct dvb_frontend_parameters {
 	uint32_t frequency;     /&#x22C6; (absolute) frequency in Hz for QAM/OFDM &#x22C6;/
-- 
1.7.1


