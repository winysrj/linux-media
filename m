Return-path: <linux-media-owner@vger.kernel.org>
Received: from smtp2.macqel.be ([109.135.2.61]:57031 "EHLO smtp2.macqel.be"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750768AbdGYImH (ORCPT <rfc822;linux-media@vger.kernel.org>);
        Tue, 25 Jul 2017 04:42:07 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp2.macqel.be (Postfix) with ESMTP id 7EEAB130F52
        for <linux-media@vger.kernel.org>; Tue, 25 Jul 2017 10:37:01 +0200 (CEST)
Received: from smtp2.macqel.be ([127.0.0.1])
        by localhost (mail.macqel.be [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id FtPg9YysNdBu for <linux-media@vger.kernel.org>;
        Tue, 25 Jul 2017 10:36:59 +0200 (CEST)
Received: from frolo.macqel.be (frolo.macqel [10.1.40.73])
        by smtp2.macqel.be (Postfix) with ESMTP id CD8B3130C83
        for <linux-media@vger.kernel.org>; Tue, 25 Jul 2017 10:36:59 +0200 (CEST)
Date: Tue, 25 Jul 2017 10:36:59 +0200
From: Philippe De Muyter <phdm@macq.eu>
To: linux-media@vger.kernel.org
Subject: linux and sony pregius cmos sensors
Message-ID: <20170725083659.GA27375@frolo.macqel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi all,

I currently investigate using sony pregius cmos sensor (imx264, e.g.)
on a imx (tegra or imx6) board.  I see that many camera vendors already
sell USB3 or IP cameras based on such chips, but is there support (or
currently in development drivers) in linux kernel for those chips ?

IIRC, they don't have a MIPI-CSI2 interface but a LVDS interface.
Fortunately there is ia chip from a FPGA vendor that can convert LVDS
to MIPI-CSI2.

Any advice or info ?

TIA

Philippe

-- 
Philippe De Muyter +32 2 6101532 Macq SA rue de l'Aeronef 2 B-1140 Bruxelles
