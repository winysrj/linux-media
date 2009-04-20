Return-path: <linux-media-owner@vger.kernel.org>
Received: from mta1.srv.hcvlny.cv.net ([167.206.4.196]:38751 "EHLO
	mta1.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbZDTUEo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 20 Apr 2009 16:04:44 -0400
Received: from steven-toths-macbook-pro.local
 (ool-45721e5a.dyn.optonline.net [69.114.30.90]) by mta1.srv.hcvlny.cv.net
 (Sun Java System Messaging Server 6.2-8.04 (built Feb 28 2007))
 with ESMTP id <0KIF0025O13OZ4Q0@mta1.srv.hcvlny.cv.net> for
 linux-media@vger.kernel.org; Mon, 20 Apr 2009 16:04:42 -0400 (EDT)
Date: Mon, 20 Apr 2009 16:04:35 -0400
From: Steven Toth <stoth@linuxtv.org>
Subject: Re: Hauppauge HVR-1500 (aka HP RM436AA#ABA)
In-reply-to: <1240255677.5388.153.camel@mountainboyzlinux0>
To: "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>
Message-id: <49ECD553.9090707@linuxtv.org>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
References: <23cedc300904170207w74f50fc1v3858b663de61094c@mail.gmail.com>
 <BAY102-W34E8EA79DEE83E18177655CF7B0@phx.gbl> <49E9C4EA.30706@linuxtv.org>
 <loom.20090420T150829-849@post.gmane.org> <49EC9A08.50603@linuxtv.org>
 <1240245715.5388.126.camel@mountainboyzlinux0> <49ECA8DD.9090708@linuxtv.org>
 <1240249684.5388.146.camel@mountainboyzlinux0> <49ECBCF0.3060806@linuxtv.org>
 <1240255677.5388.153.camel@mountainboyzlinux0>
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

>> So, under MCE find a major network ABC, NBC or CBS that works perfectly for you 
>> then locate the RF channel on antenna web.org.

> These all come in fine on mce.
> 
> KDKA-DT    2.1    25
> WTAE-DT    4.1    51
> WQED-DT 13.1    38

(Rule #2, always CC the mailing list. Don't drop them off, even by accident. An 
honest mistake on your part so I've added them back in.)

Modify your $HOME/.azap/channels.conf to look like this:

ch25:539000000:8VSB:65:68:4
ch38:614000000:8VSB:65:68:4
ch51:695000000:8VSB:65:68:4

The use the following command to tune ch25:

azap -r ch25

What happens next?

- Steve

