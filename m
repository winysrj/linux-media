Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <b24e53350901032021t2fdc4e54saec05f223d430f35@mail.gmail.com>
Date: Sat, 3 Jan 2009 23:21:09 -0500
From: "Robert Krakora" <rob.krakora@messagenetsystems.com>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>, video4linux-list@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Cc: Jerry Geis <geisj@messagenetsystems.com>
Subject: KWorld 330U Employs Samsung S5H1409X01 Demodulator
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <video4linux-list@redhat.com>

Mauro:

The KWorld 330U employs the Samsung S5H1409X01 demodulator, not the
LGDT330X.  Hence the error initializing the LGDT330X in the current source
in em28xx-dvb.c.

Best Regards,

-- 
Rob Krakora
Software Engineer
MessageNet Systems
101 East Carmel Dr. Suite 105
Carmel, IN 46032
(317)566-1677 Ext. 206
(317)663-0808 Fax
--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
