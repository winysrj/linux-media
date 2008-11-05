Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from courier.cs.helsinki.fi ([128.214.9.1] helo=mail.cs.helsinki.fi)
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <vpivaini@cs.helsinki.fi>) id 1KxqFs-0004vm-5o
	for linux-dvb@linuxtv.org; Wed, 05 Nov 2008 22:49:39 +0100
From: "Ville-Pekka Vainio" <vpivaini@cs.helsinki.fi>
To: linux-dvb@linuxtv.org
Date: Wed, 5 Nov 2008 23:49:29 +0200
References: <157f4a8c0811041600r6b3f7181oe05fd576ec2d3a64@mail.gmail.com>
In-Reply-To: <157f4a8c0811041600r6b3f7181oe05fd576ec2d3a64@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_qThEJXPBnOpNBIW"
Message-Id: <200811052349.30764.vpivaini@cs.helsinki.fi>
Subject: Re: [linux-dvb] [PATCH]Correct TT S2-3200 remote support
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

--Boundary-00=_qThEJXPBnOpNBIW
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

hudo kkow wrote:
> Patch corrects missing support for some TT S2-3200 remotes.
>
> Signed-off-by:Hudo KKow <hudokkow AT gmail.com>
>
> Thanks to Ales Jurik and Ville-Pekka Vainio for the feedback and the
> suggestions.
>
> Read it at http://www.linuxtv.org/pipermail/vdr/2008-November/018248.html

Hi,

It seems your patch wasn't quite correct, you forgot to remove 0x1012 from the 
previous set of cases and at least my editors show that you used spaces to 
indent 0x1012 when the file is indented with tabs.

So here's my attempt at fixing those two issues and an improved description. 
If it seems ok to you, could you please add your Signed-off-by as a reply? 
I'm sending the patch as an attachment since I'm afraid KMail might mangle 
the whitespace otherwise.

FYI, the TT-DVB-T 1500 entry at 
<http://linuxtv.org/wiki/index.php/DVB-T_PCI_Cards#TechnoTrend> instructs 
loading budget_ci with rc5_device=255. After applying this patch it shouldn't 
be necessary to set the rc5_device parameter anymore when loading the module.


Use the TT 1500 IR keymap for the TT T-1500 and the TT S2-3200

The Technotrend T-1500 and S2-3200 have been sold with the same remote 
controllers as the Technotrend C/S-1500. This patch loads the Technotrend 
1500 keymap for those two devices (subsystem ids 0x1012 and 0x1019) as well.

Signed-off-by: Ville-Pekka Vainio <vpivaini@cs.helsinki.fi>


-- 
Ville-Pekka Vainio

--Boundary-00=_qThEJXPBnOpNBIW
Content-Type: text/x-diff;
  charset="iso 8859-15";
  name="budget-ci-tt-t-1500-tt3200-remote.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="budget-ci-tt-t-1500-tt3200-remote.patch"

diff -r d3886881a99b linux/drivers/media/dvb/ttpci/budget-ci.c
--- a/linux/drivers/media/dvb/ttpci/budget-ci.c	Thu Oct 30 03:51:46 2008 +0000
+++ b/linux/drivers/media/dvb/ttpci/budget-ci.c	Wed Nov 05 23:07:33 2008 +0200
@@ -230,7 +230,6 @@
 	case 0x100c:
 	case 0x100f:
 	case 0x1011:
-	case 0x1012:
 		/* The hauppauge keymap is a superset of these remotes */
 		ir_input_init(input_dev, &budget_ci->ir.state,
 			      IR_TYPE_RC5, ir_codes_hauppauge_new);
@@ -241,7 +240,9 @@
 			budget_ci->ir.rc5_device = rc5_device;
 		break;
 	case 0x1010:
+	case 0x1012:
 	case 0x1017:
+	case 0x1019:
 	case 0x101a:
 		/* for the Technotrend 1500 bundled remote */
 		ir_input_init(input_dev, &budget_ci->ir.state,

--Boundary-00=_qThEJXPBnOpNBIW
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--Boundary-00=_qThEJXPBnOpNBIW--
