Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.lantan.ru ([195.128.246.20]:59962 "EHLO mail.lantan.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752278AbZKQQSo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 17 Nov 2009 11:18:44 -0500
From: Anton Myachin <antm@lantan.ru>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Date: Tue, 17 Nov 2009 21:18:39 +0500
Subject: [PATCH] dvb-apps: fixes in scan utility
Message-ID: <157C68AB74BE874882CBA1525C1D967F61530EFFD5@hyperion.intranet.lantan.ru>
Content-Language: ru-RU
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello,

I did correct work with circular polarisation (R=V)
Added call for setup_switch function for Monopoint LNBf, because somebody may use it with diseqc switch and we also should set correct polarisation.

Signed-off-by: Anton Myachin <antm@lantan.ru>

--- a/util/scan/scan.c� 2009-11-16 19:29:41.000000000 +0500
+++ b/util/scan/scan.c� 2009-11-16 20:37:44.000000000 +0500
@@ -1484,7 +1484,7 @@ static int __tune_to_transponder (int fr

������������������������������� setup_switch (frontend_fd,
��������������������������������������������� switch_pos,
-�������������������������������������������� t->polarisation == POLARISATION_VERTICAL ? 0 : 1,
+�������������������������������������������� t->polarisation == POLARISATION_VERTICAL || t->polarisation == POLARISATION_CIRCULAR_RIGHT ? 0 : 1,
��������������������������������������������� hiband);
������������������������������� usleep(50000);
������������������������������� if (hiband)
@@ -1497,7 +1497,12 @@ static int __tune_to_transponder (int fr
����������������������������������������������� lnb_type.low_val: lnb_type.high_val));
������������� ����������}
��������������� } else� {
-���������������������� /* Monopoint LNBf without switch */
+���������������������� /* Monopoint LNBf */
+���������������������� setup_switch (frontend_fd,
+������������������������������������ switch_pos,
+���������� ��������������������������t->polarisation == POLARISATION_VERTICAL || t->polarisation == POLARISATION_CIRCULAR_RIGHT ? 0 : 1,
+������������������������������������ 0);
+���������������������� usleep(50000);
����������������������� p.frequency = abs(p.frequency - lnb_type.low_val);
��������������� }
��������������� if (verbosity >= 2)
@@ -1930,7 +1935,7 @@ static void pids_dump_service_parameter_

�static char sat_polarisation (struct transponder *t)
�{
-������ return t->polarisation == POLARISATION_VERTICAL ? 'v' : 'h';
+������ return t->polarisation == POLARISATION_VERTICAL || t->polarisation == POLARISATION_CIRCULAR_RIGHT ? 'v' : 'h';
�}

�static int sat_number (struct transponder *t)


