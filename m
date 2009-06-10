Return-path: <linux-media-owner@vger.kernel.org>
Received: from relay-pt1.poste.it ([62.241.4.164]:58277 "EHLO
	relay-pt1.poste.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754907AbZFJQD1 (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Wed, 10 Jun 2009 12:03:27 -0400
Received: from nico2.od.loc (93.63.225.36) by relay-pt1.poste.it (7.3.122) (authenticated as Nicola.Sabbi@poste.it)
        id 4A2EF801000084F6 for linux-media@vger.kernel.org; Wed, 10 Jun 2009 17:43:22 +0200
From: Nico Sabbi <Nicola.Sabbi@poste.it>
To: linux-media@vger.kernel.org
Subject: Re: [linux-dvb] FlyDVB Trio PCI simultanious DVB-S/DVB-T?
Date: Wed, 10 Jun 2009 17:43:18 +0200
References: <1244648194.5258.5.camel@asrock>
In-Reply-To: <1244648194.5258.5.camel@asrock>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906101743.18690.Nicola.Sabbi@poste.it>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

On Wednesday 10 June 2009 17:36:34 sacha wrote:
> I was googling quite a lot without result. Is it possible to run
> FlyDVB Trio PCI in simultaneous mode with both DVB-S and DVB-T
> frontends? It is working under Windows.
>
> KR
>
>

no,  it's not possible, not even in windows: they share a part of the 
hardware. What's possible is using an analog and a digital source at 
the same time.
