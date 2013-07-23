Return-path: <linux-media-owner@vger.kernel.org>
Received: from omr-d01.mx.aol.com ([205.188.252.208]:46704 "EHLO
	omr-d01.mx.aol.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756955Ab3GWVqo (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Tue, 23 Jul 2013 17:46:44 -0400
Message-ID: <51EEF9D3.9090309@netscape.net>
Date: Tue, 23 Jul 2013 18:46:59 -0300
From: =?ISO-8859-1?Q?Alfredo_Jes=FAs_Delaiti?=
	<alfredodelaiti@netscape.net>
MIME-Version: 1.0
To: linux-media@vger.kernel.org
CC: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: mb86a20s and cx23885
References: <51054759.7050202@netscape.net> <20130127141633.5f751e5d@redhat.com> <5105A0C9.6070007@netscape.net> <20130128082354.607fae64@redhat.com> <5106E3EA.70307@netscape.net> <511264CF.3010002@netscape.net> <51336331.10205@netscape.net> <20130303134051.6dc038aa@redhat.com> <20130304164234.18df36a7@redhat.com> <51353591.4040709@netscape.net> <20130304233028.7bc3c86c@redhat.com> <513A6968.4070803@netscape.net> <515A0D03.7040802@netscape.net> <51E44DCA.8060702@netscape.net> <20130716053030.3fda034e.mchehab@infradead.org> <51E6A20B.8020507@netscape.net> <20130718042314.2773b7c0.mchehab@infradead.org> <51EBE721.2010204@netscape.net> <51EEEE6C.7000309@netscape.net>
In-Reply-To: <51EEEE6C.7000309@netscape.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-media-owner@vger.kernel.org
List-ID: <linux-media.vger.kernel.org>

Hi

I forgot, in this section I put "BAD" because not have picture or sound, 
but if signal.

alfredo@linux-puon:/usr/src/git/linux> git stash
Saved working directory and index state WIP on (no branch): 2827e1f 
[media] tlg2300: convert set_fontend to use DVBv5 parameters
HEAD is now at 2827e1f [media] tlg2300: convert set_fontend to use DVBv5 
parameters
alfredo@linux-puon:/usr/src/git/linux> git bisect bad /*apear tunner, 
but not tunner*/
Bisecting: 4 revisions left to test after this (roughly 3 steps)
[4fa102d5cc5b412fa3bc7cc8c24e4d9052e4f693] [media] vp702x-fe: convert 
set_fontend to use DVBv5 parameters

Is there a way to return to after with bisect without compile all?

Thanks,

Alfredo

