Return-path: <video4linux-list-bounces@redhat.com>
Message-ID: <49610159.5090909@rogers.com>
Date: Sun, 04 Jan 2009 13:35:05 -0500
From: CityK <cityk@rogers.com>
MIME-Version: 1.0
To: Douglas Schilling Landgraf <dougsland@gmail.com>
References: <b24e53350901032021t2fdc4e54saec05f223d430f35@mail.gmail.com>	<412bdbff0901032118y9dda1c2uaeb451c0874a65cd@mail.gmail.com>	<49605AFA.3000208@rogers.com>	<20090104135840.7de113de@gmail.com>	<4960EE73.1000406@rogers.com>
	<20090104152512.0f168fc5@gmail.com>
In-Reply-To: <20090104152512.0f168fc5@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: video4linux-list@redhat.com, linux-dvb@linuxtv.org,
	Chehab <mchehab@redhat.com>, linux-media <linux-media@vger.kernel.org>
Subject: Re: KWorld 330U Employs Samsung S5H1409X01 Demodulator
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

Douglas Schilling Landgraf wrote:
> CityK <cityk@rogers.com> wrote:
>> Mauro -- can you shed any light in regards the "A316" part of the name
>> descriptor ?
>>     
>
> Probably inherited from vendor/product ID, as follow:
>
> em28xx-cards.c:
>
> { USB_DEVICE(0xeb1a, 0xa316), .driver_info = EM2883_BOARD_KWORLD_HYBRID_A316 },
>                         ^^^

Ahh, very good.

Mauro, or whomever is going to end up spinning the patch incorporating
the correction regarding the demod. information, I suggest that the
descriptor "EM2883_BOARD_KWORLD_HYBRID_A316" be simultaneously changed
to "EM2883_BOARD_KWORLD_ATSC_330U" to reflect the device's more common name.



--
video4linux-list mailing list
Unsubscribe mailto:video4linux-list-request@redhat.com?subject=unsubscribe
https://www.redhat.com/mailman/listinfo/video4linux-list
