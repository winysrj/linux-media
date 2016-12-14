Return-path: <linux-media-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:43408 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755529AbcLNNSq (ORCPT
        <rfc822;linux-media@vger.kernel.org>);
        Wed, 14 Dec 2016 08:18:46 -0500
From: Mauro Carvalho Chehab <mchehab@s-opensource.com>
To: linux-media@vger.kernel.org
Cc: Gregor Jasny <gjasny@googlemail.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>
Subject: [v4l-utils PATCH 3/3] dvb-sat: add support for several BrasilSat LNBf models
Date: Wed, 14 Dec 2016 11:18:35 -0200
Message-Id: <20161214131835.11259-4-mchehab@s-opensource.com>
In-Reply-To: <20161214131835.11259-3-mchehab@s-opensource.com>
References: <20161214131835.11259-1-mchehab@s-opensource.com>
 <20161214131835.11259-2-mchehab@s-opensource.com>
 <20161214131835.11259-3-mchehab@s-opensource.com>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

There are some LNBf manufactured by BrasilSat that are
widely used in Brazil. Add support for them, based on what's
described on this document:
	http://www.brasilsat.com.br/arquivo/DataSheet1.pdf

I tested myself the custom GVT model.

Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
---
 lib/libdvbv5/dvb-sat.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/lib/libdvbv5/dvb-sat.c b/lib/libdvbv5/dvb-sat.c
index bde0cfa3accb..7eb02284e3c4 100644
--- a/lib/libdvbv5/dvb-sat.c
+++ b/lib/libdvbv5/dvb-sat.c
@@ -143,6 +143,55 @@ static const struct dvb_sat_lnb_priv lnb[] = {
 		.freqrange = {
 			{ 11710, 12751, 10678, 0 }
 		}
+	}, {
+		.desc = {
+			.name = N_("BrasilSat Stacked"),
+			.alias = "STACKED-BRASILSAT",
+		},
+		.freqrange = {
+			{ 10700, 11700, 9710, 0, POLARIZATION_H },
+			{ 10700, 11700, 9750, 0, POLARIZATION_H },
+		},
+	}, {
+		.desc = {
+			.name = N_("BrasilSat Oi"),
+			.alias = "OI-BRASILSAT",
+		},
+		.freqrange = {
+			{ 10950, 11200, 10000, 11700 },
+			{ 11800, 12200, 10445, 0 },
+		}
+	}, {
+		.desc = {
+			.name = N_("BrasilSat Amazonas 1/2 - 3 Oscilators"),
+			.alias = "AMAZONAS",
+		},
+		.freqrange = {
+			{ 11037, 11450, 9670, 0, POLARIZATION_V },
+			{ 11770, 12070, 9922, 0, POLARIZATION_H },
+			{ 10950, 11280, 10000, 0, POLARIZATION_H },
+		},
+	}, {
+		.desc = {
+			.name = N_("BrasilSat Amazonas 1/2 - 2 Oscilators"),
+			.alias = "AMAZONAS",
+		},
+		.freqrange = {
+			{ 11037, 11360, 9670, 0, POLARIZATION_V },
+			{ 11780, 12150, 10000, 0, POLARIZATION_H },
+			{ 10950, 11280, 10000, 0, POLARIZATION_H },
+		},
+	}, {
+		.desc = {
+			.name = N_("BrasilSat custom GVT"),
+			.alias = "GVT-BRASILSAT",
+		},
+		.freqrange = {
+			{ 11010.5, 11067.5, 12860, 0, POLARIZATION_V },
+			{ 11704.0, 11941.0, 13435, 0, POLARIZATION_V },
+			{ 10962.5, 11199.5, 13112, 0, POLARIZATION_H },
+			{ 11704.0, 12188.0, 13138, 0, POLARIZATION_H },
+		},
 	},
 };
 
-- 
2.9.3

