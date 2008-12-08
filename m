Return-path: <linux-dvb-bounces+mchehab=infradead.org@linuxtv.org>
Received: from yx-out-2324.google.com ([74.125.44.30])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <morgan.torvolt@gmail.com>) id 1L9ft6-0001U5-NN
	for linux-dvb@linuxtv.org; Mon, 08 Dec 2008 14:11:01 +0100
Received: by yx-out-2324.google.com with SMTP id 8so413573yxg.41
	for <linux-dvb@linuxtv.org>; Mon, 08 Dec 2008 05:10:55 -0800 (PST)
Message-ID: <3cc3561f0812080510i3dd306b2o3b241c88e314ff3e@mail.gmail.com>
Date: Mon, 8 Dec 2008 13:10:55 +0000
From: "=?ISO-8859-1?Q?Morgan_T=F8rvolt?=" <morgan.torvolt@gmail.com>
To: "Christophe Thommeret" <hftom@free.fr>
In-Reply-To: <200812050205.54408.hftom@free.fr>
MIME-Version: 1.0
Content-Disposition: inline
References: <3cc3561f0812041458m5344f0e8v7e0dec95e91e7735@mail.gmail.com>
	<200812050202.52582.hftom@free.fr> <200812050205.54408.hftom@free.fr>
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] A bug in libdvben50221?
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces+mchehab=infradead.org@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

Thanks a lot Christophe.

Maybe something like this should be done in the official version as well?


-Morgan-

On Fri, Dec 5, 2008 at 1:05 AM, Christophe Thommeret <hftom@free.fr> wrote:
> Le vendredi 5 d=E9cembre 2008 02:02:52 Christophe Thommeret, vous avez =
=E9crit :
>> Le jeudi 4 d=E9cembre 2008 23:58:31 Morgan T=F8rvolt, vous avez =E9crit :
>> > Hi all.
>> >
>> > This might be a stupid question, please feel free to call me a moron
>> > and tell me how to solve this little problem I am having. I have tried
>> > getting in touch with someone on the irc channel to help me sort this
>> > out without much luck. Hopefully someone here has some knowledge of
>> > the libdvben50221 library. I would imagine that very many use this
>> > library with their dvb cards, so there should be someone out there.
>> >
>> > The camthread in gnutv, which continuously polls the stdcam, calls the
>> > stdcam's poll function (obviously). The poll function is in my
>> > pointing to the en50221_stdcam_llci_poll function. This function in
>> > turn calls en50221_tl_poll, but without passing the return value of
>> > this on to the camthread function of gnutv. What happened in my case
>> > was that the transport layer crashed in some obscure way (this has
>> > only happened once actually), and the en50221_tl_poll function
>> > returned -1 all the time, and set the error state to be -3, which is
>> > EN50221ERR_TIMEOUT. It did not recover in over an hour of waiting.
>> > This message was spamming my console window:
>> > en50221_stdcam_llci_poll: Error reported by stack:-3
>> >
>> > After looking high and low for a way to be able to detect this state,
>> > I have come up with nothing. I cannot read the error value directly
>> > out of the stuct as it is a forward declaration in the header file and
>> > actually declared in the .c file. I can access the error data using
>> > the en50221_tl_get_error() function, but that only tells me that at
>> > some point there was an error with the given error value.
>> >
>> > At least on my cam I get this message often when I start a program:
>> > "en50221_stdcam_llci_poll: Error reported by stack:-7", which is a
>> > message I can test with. My testing suggest that the error is set to
>> > -7 and is left there until a new error occurs. In other words, it is
>> > not possible to detect if the error -7 occurs every second, every
>> > minute, or just once at the start and no errors since then. The same
>> > problem exists with the timeout error I had. gnutv could have detected
>> > that there had been a timeout error, but could in no way I can see,
>> > find out if it had resolved itself or not.
>> >
>> > The error I saw was a timeout error that happened after more than 24
>> > hours from starting the program, and the transport layer was returning
>> > -3 continuously.
>> >
>> > I can think of a few ways to solve this problem.
>> >  * One would be a callback function on transport layer error in the
>> > stdcam * Have an error counter in the transport layer struct, and a
>> > function to read the counter. Must be reflected in the session layer as
>> > well it seems.
>> >  * Return the transport layer poll's return value in some way from the
>> > stdcam poll function. Possibly by setting adding to the stdcam_status
>> > enum a value like "EN50221_STDCAM_TL_ERROR". Maybe a bitshifted value
>> > as well? It should then be easy to check the error using the
>> > en50221_tl_get_error function.
>> >  * This is already solved trough some other solution, and I have been
>> > to blind to see it all along.
>> >
>> > I prefer the options from bottom to top.
>> > Any takers?
>>
>> Look at en50221_stdcam_llci_poll(..) in the joined file.
>> This is how i solved that.
>
> Forgot to say: don't try to use that file as is, it may have some other
> modifications that you don't want.
>
> --
> Christophe Thommeret
>
>

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
