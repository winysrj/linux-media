Return-path: <linux-media-owner@vger.kernel.org>
Received: from dub004-omc2s28.hotmail.com ([157.55.1.167]:57845 "EHLO
	DUB004-OMC2S28.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753969AbbHCOHi convert rfc822-to-8bit
	(ORCPT <rfc822;linux-media@vger.kernel.org>);
	Mon, 3 Aug 2015 10:07:38 -0400
Message-ID: <DUB128-W255CECEF72511B6BBD79E19C770@phx.gbl>
From: David Binderman <dcb314@hotmail.com>
To: "prabhakar.csengg@gmail.com" <prabhakar.csengg@gmail.com>,
	"linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Subject: drivers/media/platform/am437x/am437x-vpfe.c:1698: bad test ?
Date: Mon, 3 Aug 2015 14:02:33 +0000
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hello there,

drivers/media/platform/am437x/am437x-vpfe.c:1698:27: warning: self-comparison always evaluates to true [-Wtautological-compare]

     if (client->addr == curr_client->addr &&
            client->adapter->nr == client->adapter->nr) {

maybe

     if (client->addr == curr_client->addr &&
            client->adapter->nr == curr_client->adapter->nr) {

Regards

David Binderman

 		 	   		  