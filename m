Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-qt0-f169.google.com ([209.85.216.169]:34183 "EHLO
	mail-qt0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbcGHW4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Fri, 8 Jul 2016 18:56:24 -0400
Received: by mail-qt0-f169.google.com with SMTP id u25so4233925qtb.1
        for <linux-media@vger.kernel.org>; Fri, 08 Jul 2016 15:56:24 -0700 (PDT)
MIME-Version: 1.0
From: Vinson Lee <vlee@freedesktop.org>
Date: Fri, 8 Jul 2016 15:55:44 -0700
Message-ID: <CACKvgLEOdetneSdhwmdayYzu+eadYy4hoAT1nBo3U37pSJWCPg@mail.gmail.com>
Subject: =?UTF-8?Q?linux=2Dnext_build_error_=22cec=2Dadap=2Ec=3A141=3A_error=3A_unkno?=
	=?UTF-8?Q?wn_field_=E2=80=98lost=5Fmsgs=E2=80=99_specified_in_initializer=22?=
To: Hans Verkuil <hans.verkuil@cisco.com>,
	Mauro Carvalho Chehab <mchehab@s-opensource.com>,
	Kamil Debski <kamil@wypas.org>, k.debski@samsung.com
Cc: linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi.

Commit 9881fe0ca187 "[media] cec: add HDMI CEC framework (adapter)"
introduced this build error with GCC 4.4.

  CC [M]  drivers/staging/media/cec/cec-adap.o
drivers/staging/media/cec/cec-adap.c: In function ‘cec_queue_msg_fh’:
drivers/staging/media/cec/cec-adap.c:141: error: unknown field
‘lost_msgs’ specified in initializer

Cheers,
Vinson
