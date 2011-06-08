Return-path: <mchehab@pedra>
Received: from mx1.redhat.com ([209.132.183.28]:6474 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1FHCUJ (ORCPT <rfc822;linux-media@vger.kernel.org>);
	Tue, 7 Jun 2011 22:20:09 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p582K8cj010424
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 22:20:09 -0400
Received: from [10.3.236.210] (vpn-236-210.phx2.redhat.com [10.3.236.210])
	by int-mx01.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP id p582K7g1014694
	for <linux-media@vger.kernel.org>; Tue, 7 Jun 2011 22:20:08 -0400
Message-ID: <4DEEDC57.7050707@redhat.com>
Date: Tue, 07 Jun 2011 23:20:07 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
MIME-Version: 1.0
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: [PATCH 00/15] DVB Frontend Documentation patches
References: <20110607224542.597d46bc@pedra>
In-Reply-To: <20110607224542.597d46bc@pedra>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Em 07-06-2011 22:45, Mauro Carvalho Chehab escreveu:
> This series of patches updates the DVB v5 documentation, sinchronizing
> the current implementation with the API spec.
> Among other things, it:
> 	- adds a logic that discovers API gaps between the header
> 	  file and the API specs;
> 	- adds/fixes the DVB S2API (DVBv5) additions;
> 	- adds the FE_ATSC frontend descriptions (both v3 and v5);
> 	- adds a relation of DVBv5 parameters for usage for each
> 	  supported delivery system.
> 
> The API updates were made at the best effort basis, by doing a sort
> of "reverse engineering" approach, e. g., by looking at the code
> and trying to figure out what changed, why and how. Due to that,
> I bet people will find errors on it. Also, English is not my native
> language, and I didn't have time for doing a language review.
> 
> so I'm sure that language/style/typo fixes are needed.
> 
> So, I'd like to encourage people to carefully read the docs and
> send us patches with fixes.
> 
> Anyway, as the situation after those patches are better than before them,
> I'm pushing it to the main repository. This helps to review, as the
> linuxtv scripts will re-format the DocBook into html.

The linuxtv API specs were updated at linuxtv.org. For those that want 
to review, the changes were at chapter 9 of the API spec[1], mainly at:

http://linuxtv.org/downloads/v4l-dvb-apis/dvb_frontend.html
http://linuxtv.org/downloads/v4l-dvb-apis/FE_GET_SET_PROPERTY.html
http://linuxtv.org/downloads/v4l-dvb-apis/frontend_h.html

[1] http://linuxtv.org/downloads/v4l-dvb-apis/

Cheers,
Mauro.
