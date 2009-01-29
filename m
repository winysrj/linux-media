Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from gateway06.websitewelcome.com ([69.93.35.3])
	by www.linuxtv.org with smtp (Exim 4.63)
	(envelope-from <skerit@kipdola.com>) id 1LSWZ5-00051s-Kf
	for linux-dvb@linuxtv.org; Thu, 29 Jan 2009 14:04:16 +0100
Received: from [77.109.104.35] (port=34564 helo=[127.0.0.1])
	by gator143.hostgator.com with esmtpa (Exim 4.69)
	(envelope-from <skerit@kipdola.com>) id 1LSWYw-0002PS-Ac
	for linux-dvb@linuxtv.org; Thu, 29 Jan 2009 07:04:06 -0600
Message-ID: <4981A93A.7080909@kipdola.com>
Date: Thu, 29 Jan 2009 14:03:54 +0100
From: Jelle De Loecker <skerit@kipdola.com>
MIME-Version: 1.0
To: linux-dvb@linuxtv.org
Subject: [linux-dvb] Extracting video stream
Reply-To: linux-media@vger.kernel.org
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

Hi everyone,

This is not a real -dvb question, but -media seemed too official.

A device of mine is serving a video stream on a certain port, (Hawking 
HNC210, video surveillance cam)
unfortunately it uses its own (very simple) protocol: it's a bunch of 
jpegs in a row.

I have this script that checks the stream every second and creates a 
jpeg out of it,
but I really want a continuous video stream. Is there a way to do this?

This is the script:

#!/usr/bin/perl
use IO::Socket;
#SET WHERE CAMERA IS
$sock = new IO::Socket::INET (PeerAddr => '10.11.0.101',
                                PeerPort => 4321,
                                Proto    => 'tcp',
                                Timeout  => 1);
#do it again forever
while (1){
#sleep timeout (this value give us 1fps)
select(undef, undef, undef, 0.5);

$sock->send("0110\n");
$sock->read($size, 2);
$sock->read($j1, 1);
$sock->read($j2, 1);
$j1=oct("0x".unpack("H*", $j1));
$j2=oct("0x".unpack("H*", $j2));
#print "J1_USERS:".$j1."\n";
#print "J2:".$j2."\n";
$size=oct("0x".unpack("H*", $size));
#print "SIZE:".$size."\n";
if ($size != 0) {
$sock->read($data, $size);
open OUTF, "> /var/www/hawking.jpg" or die "Can't open $outfile : $!";
print OUTF $data;
close OUTF;
}
}

Greetings,
Jelle De Loecker

_______________________________________________
linux-dvb users mailing list
For V4L/DVB development, please use instead linux-media@vger.kernel.org
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
