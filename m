Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from www.viadmin.org ([195.145.128.101])
	by mail.linuxtv.org with esmtp (Exim 4.69)
	(envelope-from <henrik-dvb@prak.org>) id 1MvobF-0005SS-TH
	for linux-dvb@linuxtv.org; Thu, 08 Oct 2009 10:43:50 +0200
Received: from localhost (localhost.localdomain [127.0.0.1])
	by www.viadmin.org (Postfix) with ESMTP id CA007552CD
	for <linux-dvb@linuxtv.org>; Thu,  8 Oct 2009 10:43:13 +0200 (CEST)
Received: from www.viadmin.org ([127.0.0.1])
	by localhost (www.viadmin.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id R1SODwtixsT9 for <linux-dvb@linuxtv.org>;
	Thu,  8 Oct 2009 10:43:03 +0200 (CEST)
Date: Thu, 8 Oct 2009 10:43:02 +0200
From: "H. Langos" <henrik-dvb@prak.org>
To: linux-dvb@linuxtv.org
Message-ID: <20091008084302.GD6384@www.viadmin.org>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] linuxtv.org/wiki Please increase maximum execution time
Reply-To: linux-media@vger.kernel.org
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/options/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>


I am working on 
http://www.linuxtv.org/wiki/index.php/Template:DVB-T_USB_Devices_ListData
and I get errors like this when trying to save the page:

Fatal error: Maximum execution time of 30 seconds exceeded in
/var/www/wiki/extensions/ParserFunctions/ParserFunctions.php on line 107

or 

Fatal error: Maximum execution time of 30 seconds exceeded in
/var/www/wiki/includes/parser/Preprocessor_DOM.php on line 1337


This is probably due to the extensive usage of templates and 
parserfunctions. even though those are well within the defined 
limits when rendering the page:

> NewPP limit report
> Preprocessor node count: 139929/1000000
> Post-expand include size: 282253/2097152 bytes
> Template argument size: 509259/2097152 bytes
> Expensive parser function count: 0/100

So my guess is that the server is under heavy load by something else and
therefore the php engine hits that 30 seconds limit.

would be nice if somebody could take a look at the server and possibly
increase the maximum execution time in the php.ini

cheers
-henrik



_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
