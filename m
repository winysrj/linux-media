Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51332 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab1J3NHi (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Sun, 30 Oct 2011 09:07:38 -0400
Received: by faan17 with SMTP id n17so4815424faa.19
        for <linux-media@vger.kernel.org>; Sun, 30 Oct 2011 06:07:37 -0700 (PDT)
MIME-Version: 1.0
Date: Sun, 30 Oct 2011 14:07:37 +0100
Message-ID: <CAPEGoTDA9BztLrSWBKFSF0jbOH=-bKZPZGB7t_iTfmwhXuGJ6Q@mail.gmail.com>
Subject: Initial tuning file for DVB-C network of Delta in the netherlands
From: Hein Rigolo <rigolo@gmail.com>
To: linux-media@vger.kernel.org,
	Christoph Pfister <christophpfister@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Here is an initial tuning file for the DVB-C network of Delta in the
netherlands:


# Initial Tuning file for nl-DELTA
# This file only lists the main
# frequency. You still need to do
# a network scan to find other
# transponders.
#
#
C 402000000 6875000 NONE QAM64 # Main Frequency


Could this be added to dvb-apps list of initial tuning files?


Hein
