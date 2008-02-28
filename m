Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from rv-out-0910.google.com ([209.85.198.190])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <drescherjm@gmail.com>) id 1JUpbw-0001PP-PT
	for linux-dvb@linuxtv.org; Thu, 28 Feb 2008 21:44:12 +0100
Received: by rv-out-0910.google.com with SMTP id b22so2832837rvf.41
	for <linux-dvb@linuxtv.org>; Thu, 28 Feb 2008 12:43:56 -0800 (PST)
Message-ID: <387ee2020802281243y5dca7169mcb772645fdf1f23c@mail.gmail.com>
Date: Thu, 28 Feb 2008 15:43:56 -0500
From: "John Drescher" <drescherjm@gmail.com>
To: "Jelle de Jong" <jelledejong@powercraft.nl>
In-Reply-To: <47C71C18.90607@powercraft.nl>
MIME-Version: 1.0
Content-Disposition: inline
References: <47C71C18.90607@powercraft.nl>
Cc: linux-dvb <linux-dvb@linuxtv.org>
Subject: Re: [linux-dvb] v4l-dvb-experimental will not compile on debian sid
	2.6.24-1-686
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

On Thu, Feb 28, 2008 at 3:39 PM, Jelle de Jong
<jelledejong@powercraft.nl> wrote:
> cd $HOME
>  hg clone http://mcentral.de/hg/~mrec/v4l-dvb-experimental
>  cd v4l-dvb-experimental
>  make
>  sudo make install
>
>  v4l-dvb-experimental will not compile on debian sid 2.6.24-1-686
>
>  If you guys need more information i will sent it to the list.
>
Can you post what error you are getting. Also, since this is a live
build from the repository there are times when parts of the build will
fail.

John

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
