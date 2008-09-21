Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
From: Christophe Thommeret <hftom@free.fr>
To: Steven Toth <stoth@linuxtv.org>,
	"linux-dvb" <linux-dvb@linuxtv.org>
Date: Sun, 21 Sep 2008 19:05:34 +0200
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200809211905.34424.hftom@free.fr>
Subject: [linux-dvb] hvr4000-s2api + QAM_AUTO
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

Hi Steve,

I've managed to add S2 support to kaffeine, so it can scan and zap.
However, i have a little problem with DVB-S:
Before tuning to S2, S channels tune well with QAM_AUTO.
But after having tuned to S2 channels, i can no more lock on S ones until i 
set modulation to QPSK insteed of QAM_AUTO for these S channels.
Is this known?

-- 
Christophe Thommeret


_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
