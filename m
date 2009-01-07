Return-path: <video4linux-list-bounces@redhat.com>
Date: Wed, 7 Jan 2009 07:35:00 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: stanley.miao@windriver.com
Message-ID: <20090107073500.6fa6fae2@pedra.chehab.org>
In-Reply-To: <1231299123.10775.12.camel@localhost>
References: <1231299123.10775.12.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com,
	Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: Re: Does video4linux has a git tree ?
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/mailman/private/video4linux-list>
List-Post: <mailto:video4linux-list@redhat.com>
List-Help: <mailto:video4linux-list-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/video4linux-list>,
	<mailto:video4linux-list-request@redhat.com?subject=subscribe>
Sender: video4linux-list-bounces@redhat.com
Errors-To: video4linux-list-bounces@redhat.com
List-ID: <linux-media.vger.kernel.org>

On Wed, 07 Jan 2009 11:32:03 +0800
"stanley.miao" <stanley.miao@windriver.com> wrote:

> Does video4linux has a git tree ? 

Yes. The trees are described at:
	http://linuxtv.org/hg/

> If I submit a v4l2 driver patch, which tree should it apply to ?
It is better to write against the Mercurial tree:
	http://linuxtv.org/hg/v4l-dvb/

Since we have some backport code there, to allow users to test the code against older kernels.

Btw, Please address development issues on the newer v4l/dvb ML
(linux-media@vger.kernel.org). Since Jan, 2, this is the official tree for
v4l/dvb development.

Cheers,
Mauro

--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
