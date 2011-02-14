Return-path: <mchehab@pedra>
Received: from proofpoint-cluster.metrocast.net ([65.175.128.136]:54836 "EHLO
	proofpoint-cluster.metrocast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752921Ab1BNLwv (ORCPT
	<rfc822;linux-media@vger.kernel.org>);
	Mon, 14 Feb 2011 06:52:51 -0500
References: <1297647870.19186.69.camel@localhost> <20110214090712.1c17818e@endymion.delvare>
In-Reply-To: <20110214090712.1c17818e@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT FIXES for 2.6.38] Fix cx23885 and cx25840 regressions
From: Andy Walls <awalls@md.metrocast.net>
Date: Mon, 14 Feb 2011 06:52:47 -0500
To: Jean Delvare <khali@linux-fr.org>
CC: linux-media@vger.kernel.org,
	Devin Heitmueller <dheitmueller@kernellabs.com>,
	Mark Zimmerman <markzimm@frii.com>,
	Sven Barth <pascaldragon@googlemail.com>, stoth@kernellabs.com,
	hverkuil@xs4all.nl
Message-ID: <8976763d-c799-4c4d-a2ed-8560df756ebc@email.android.com>
List-ID: <linux-media.vger.kernel.org>
Sender: <mchehab@pedra>

Jean Delvare <khali@linux-fr.org> wrote:


 
>> Andy Walls (2):
>>       cx23885: Revert "Check for slave nack on all transactions"
>
>Thanks for fixing my mistakes!
>

Jean,

No problem.

I was the one who actually asked for your patch to go in without checking the hardware behavior carefully.  So I jointly own the mistake.  :)  I'll shoulder some of the blame. 

Regards,
Andy

