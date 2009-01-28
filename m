Return-path: <linux-media-owner@vger.kernel.org>
Received: from ayden.softclick-it.de ([217.160.202.102]:56952 "EHLO
	ayden.softclick-it.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751542AbZA1Bdn (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 27 Jan 2009 20:33:43 -0500
Message-ID: <497FB613.4040809@to-st.de>
Date: Wed, 28 Jan 2009 02:34:11 +0100
From: Tobias Stoeber <tobi@to-st.de>
Reply-To: tobi@to-st.de
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
CC: BOUWSMA Barry <freebeer.bouwsma@gmail.com>,
	linux-media@vger.kernel.org,
	"DVB mailin' list thingy" <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] Upcoming DVB-T channel changes for HH (Hamburg)
References: <alpine.DEB.2.00.0901231745330.15516@ybpnyubfg.ybpnyqbznva>	 <497A27F7.8020201@to-st.de>	 <alpine.DEB.2.00.0901232241530.15738@ybpnyubfg.ybpnyqbznva>	 <19a3b7a80901261228v393f5fcbv7559b573c0ca1539@mail.gmail.com>	 <alpine.DEB.2.00.0901262214200.15738@ybpnyubfg.ybpnyqbznva>	 <497EC855.7050301@to-st.de>	 <19a3b7a80901270237n761240bbn2627f782ddbffa29@mail.gmail.com>	 <497EF972.6090207@to-st.de>	 <alpine.DEB.2.00.0901271748160.15738@ybpnyubfg.ybpnyqbznva>	 <497F8EB1.2050004@to-st.de> <1233101550.2687.53.camel@pc10.localdom.local>
In-Reply-To: <1233101550.2687.53.camel@pc10.localdom.local>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi,

hermann pitton schrieb:
> The reverse effect will be, we have it already with federal state scan
> files now, that we likely will see more questions about why the hell I
> don't get this one and tuning failed ... 

Regarding the de-Sachsen-Anhalt file, apart from 3 or 4 frequency 
entries the rest is useless being within the state, because regarding 
transmitters the areas are mostly not coordinated.

Brocken and Magdeburg are the only sites with Sachsen-Anhalt that are 
corrdinated.

In fact, it is more common, that transmitters here are coordinated with 
sites from others states, e.g. "ARD-Das Erste" multiplex in Halle/Saale 
(Sachsen-Anhalt/Saxony-Anhalt) are coordinated with Leipzig 
(Sachsen/Saxony) and Gera (Thüringen/Thuringia), because this area is 
also topographically adjunct. "ZDF" multiplex is coordinated between 
Hale/Saale and Leipzig ...

> To share a center frequency over several federal states under such
> conditions seems to be plain wrong and I wonder if there was a rule.

This does not matter, as the transmitters in Brauschweig 
(Niedersachsen/Lower Saxony) and Halle/Saale (Sachsen-Anhalt) don't 
interfere with each other (the sites are more than 140 km apart) and 
there is a buffer zone of about 40 - 50 km between them, where you need 
a directed roof antenna to either receive one of them.

As I've experienced so far while travelling, that there are only very 
small parts in my federal state (Bundesland) of Sachsen-Anhalt where one 
can receive more than one transmitter site (and in most of this cases, a 
roof antenna is required, so you would normally have to direct this to a 
specific transmitter).

Well, I believe both scenarios(scan file for federal state versus scan 
file for a DVB-T region) have their pros and cons. :(

Fortunately programs like "Kaffeine" offer a full auto scan ...

Regards, Tobias
