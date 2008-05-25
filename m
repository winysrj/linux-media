Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from n42.bullet.mail.ukl.yahoo.com ([87.248.110.175])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <eallaud@yahoo.fr>) id 1K06Su-0000nx-Ox
	for linux-dvb@linuxtv.org; Sun, 25 May 2008 05:00:10 +0200
Date: Sat, 24 May 2008 22:52:42 -0400
From: manu <eallaud@yahoo.fr>
To: Linux DVB Mailing List <linux-dvb@linuxtv.org>
References: <1211682529l.9766l.0l@manu-laptop>
In-Reply-To: <1211682529l.9766l.0l@manu-laptop> (from eallaud@yahoo.fr on
	Sat May 24 22:28:49 2008)
Message-Id: <1211683962l.9766l.2l@manu-laptop>
MIME-Version: 1.0
Content-Disposition: inline
Subject: [linux-dvb] Re :  [PATCH]: TT-3200 remote patch
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
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

On 05/24/2008 10:28:49 PM, manu wrote:
> 	Hi all,
> here is a patch to enable TT-3200 remote. It works for me but:
> - I dont know the RC device so I set it to RC_DEVICE_ANY;
> - I get keys when I push buttons on the remote, but for some reason
> one 
> puts my computer on sleep. I already checked the ir keymap and I dont 
> see the problem, if someone could give it a shot...
> - I dont know how to test which remote is used, I based the detection 
> on the product id (0x1019), but all other cases are handled the same 
> way so...
> Anyway, any comments are more than welcome.
> 


OK new version with the bad keymap corrected (bad copy-paste :( ).

Signed-off-by: Emmanuel ALLAUD <eallaud@yahoo.fr>

Bye
Manu


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
