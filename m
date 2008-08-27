Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from smtp-out003.kontent.com ([81.88.40.217])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <oliver@neukum.org>) id 1KYHWB-0006sW-64
	for linux-dvb@linuxtv.org; Wed, 27 Aug 2008 11:40:49 +0200
From: Oliver Neukum <oliver@neukum.org>
To: linux-dvb@linuxtv.org
Date: Wed, 27 Aug 2008 11:41:55 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200808271141.55546.oliver@neukum.org>
Cc: linux-pm@lists.linux-foundation.org
Subject: [linux-dvb] question on struct dvb_frontend_ops.sleep
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

Hi,

could somebody explain to me what the semantics of this call is?
It seems like dvbcore uses it to tell a device that it may power down.
But when is it to power up again? Is powering up implied in every
other method of the API? Can these methods sleep?

	Regards
		Oliver

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
