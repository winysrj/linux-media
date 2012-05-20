Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:44762 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab2ETMMq (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 20 May 2012 08:12:46 -0400
Received: by obbtb18 with SMTP id tb18so6610711obb.19
        for <linux-media@vger.kernel.org>; Sun, 20 May 2012 05:12:45 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 20 May 2012 14:12:45 +0200
Message-ID: <CALqZwhTe-PpzJk=F+2HdoDZ3rt07xgxPz6tgLqoJ6h8yzAhEmQ@mail.gmail.com>
Subject: Scan file fr-Rennes
From: Christophe SCHELCHER <cschelcher@gmail.com>
To: linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi All,

I managed to get a working scan file for this location (France -
Rennes) and the one provided is a bit outdated. I've checked in the
tree and it has simply been deleted for exactly the same reason.

I successfully used the following replacement of
/usr/share/dvb/dvb-t/fr-Rennes :

# Rennes - France
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 474000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 626000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 522000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 698000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 602000000 8MHz AUTO NONE QAM64 8k AUTO NONE
T 498000000 8MHz AUTO NONE QAM64 8k AUTO NONE

Multiplexes have changed since a few years when all the country felt
into full DVB-T. Previous file was using transitory multiplexes.

Could it be possible to update this file on the tree ?

Thanks in advance for your help.

Best regards,
Christophe
