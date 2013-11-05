Return-path: <linux-media-owner@vger.kernel.org>
Received: from mail.mimuw.edu.pl ([193.0.96.6]:36285 "EHLO mail.mimuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753922Ab3KEMGF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-media@vger.kernel.org>); Tue, 5 Nov 2013 07:06:05 -0500
Message-ID: <20131105130559.23363zby3eqwo6jr@mail.mimuw.edu.pl>
Date: Tue, 05 Nov 2013 13:05:59 +0100
From: "Janusz S. Bien" <jsbien@mimuw.edu.pl>
To: linux-media@vger.kernel.org
Cc: Roland Scheidegger <rscheidegger_lists@hispeed.ch>,
	"wessels.tobias" <wessels.tobias@arcor.de>
Subject: Re: [PATCH] [media] az6007: support Technisat Cablestar Combo HDCI
 (minus remote)
References: <1383421772-28243-1-git-send-email-rscheidegger_lists@hispeed.ch>
 <20131105071422.16618olr3fxev83i@mail.mimuw.edu.pl>
In-Reply-To: <20131105071422.16618olr3fxev83i@mail.mimuw.edu.pl>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Quote/Cytat - "Janusz S. Bien" <jsbien@mimuw.edu.pl> (Tue 05 Nov 2013  
07:14:22 AM CET):

> Thank you very much for the patch.
>
> Quote/Cytat - Roland Scheidegger <rscheidegger_lists@hispeed.ch>  
> (Sat  02 Nov 2013 08:49:32 PM CET):
>
> [...]
>
>> Originally based on idea found on
>> http://www.linuxtv.org/wiki/index.php/TechniSat_CableStar_Combo_HD_CI   
>> claiming
>> only id needs to be added (but failed to mention it only worked because the
>> driver couldn't find the h7 drx-k firmware...).
>
> Together with Tobias Wessel, another user of the device, we have   
> updated and extended the wiki entry.
>
> The problem is that although I use the same system as Tobias (Debian  
>  wheezy) and it seems we installed media_build in the identical way,  
> it  works OK for Tobias but not for me,

My problem was solved by Tobias - thank you very much! As could be  
expected, I've installed the software differently...

I have erroneusly assumed that a patch posted on the list is  
immediately included  http://git.linuxtv.org/media_build.git.

I see it now at

https://patchwork.linuxtv.org/patch/20558/

together with my previous misleading letter...

Regards

Janusz

-- 
Prof. dr hab. Janusz S. Bień -  Uniwersytet Warszawski (Katedra  
Lingwistyki Formalnej)
Prof. Janusz S. Bień - University of Warsaw (Formal Linguistics Department)
jsbien@uw.edu.pl, jsbien@mimuw.edu.pl, http://fleksem.klf.uw.edu.pl/~jsbien/
