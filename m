Return-path: <linux-dvb-bounces@linuxtv.org>
Received: from mail1.perspektivbredband.net ([81.186.254.13])
	by www.linuxtv.org with esmtp (Exim 4.63)
	(envelope-from <p.blomqvist@lsn.se>) id 1JOKoN-0006pV-0h
	for linux-dvb@linuxtv.org; Sun, 10 Feb 2008 23:38:11 +0100
Message-ID: <47AF7CBD.7080303@lsn.se>
Date: Sun, 10 Feb 2008 23:37:49 +0100
From: Per Blomqvist <p.blomqvist@lsn.se>
MIME-Version: 1.0
To: hermann pitton <hermann-pitton@arcor.de>
References: <47AB7865.5090008@lsn.se> <47AC7925.8050709@rogers.com>	
	<47ACF3AF.40201@lsn.se> <1202646599.22109.17.camel@anden.nu>	
	<47AF0A2B.5080603@lsn.se>
	<1202663654.28689.27.camel@pc08.localdom.local>
In-Reply-To: <1202663654.28689.27.camel@pc08.localdom.local>
Content-Type: multipart/mixed; boundary="------------010507030709010405050303"
Cc: linux-dvb@linuxtv.org
Subject: Re: [linux-dvb] Help! I cant view video. BUT I can scan!!
List-Unsubscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=unsubscribe>
List-Archive: <http://www.linuxtv.org/pipermail/linux-dvb>
List-Post: <mailto:linux-dvb@linuxtv.org>
List-Help: <mailto:linux-dvb-request@linuxtv.org?subject=help>
List-Subscribe: <http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb>,
	<mailto:linux-dvb-request@linuxtv.org?subject=subscribe>
Sender: linux-dvb-bounces@linuxtv.org
Errors-To: linux-dvb-bounces@linuxtv.org
List-ID: <linux-dvb@linuxtv.org>

This is a multi-part message in MIME format.
--------------010507030709010405050303
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

Thanx! Now it works!!

Watching some Danish (Dansk) channel, about Napoleon.

Thanx again, for mocking me up.. It was the channel.conf, that was wrong

The channel.conf -file that I used before, was 6 month old and from my=20
previous computer.
(Now "dvbscan" doesn't detect anything on that bandwidth. And that "TV6"=20
was on that..

If I run dvdscan against the closest mayor city (Malm=C3=B6 in my case, h=
ere=20
in south Sweden), it only tunedin encrypted channels. BUT, against  all=20
of Denmark (file "dk-All") I get a some..

Its strange though.. I CAN SEE "TV6" unencrypted, but in Windows XP. But=20
there with A program called "PowerCinema" is used (in XP OS).
(tuning is a fuzz there also, I believe "PowerCinema" download channels=20
and guides and what, from the internet. It would maybe be a point to=20
retrieve its (channel) configure file. I have looked, but found none.

Another question now, how is all these "initial-tuning-data" created??

redeb:~/.tzap# cat dk-All
# Denmark, whole country
# Created from http://www.digi-tv.dk/Indhold_og_tilbud/frekvenser.asp
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 482000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 506000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 538000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 554000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 602000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 658000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 682000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 690000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 714000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 738000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 778000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 826000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE
T 834000000 8MHz 2/3 NONE QAM64 8k 1/4 NONE

redeb:~/.tzap# cat se-Malmo
# Sweden - Malm=C3=B6
# T freq bw fec_hi fec_lo mod transmission-mode guard-interval hierarchy
T 482000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE
T 506000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE
T 618000000 8MHz 2/3 NONE QAM64 8k 1/8 NONE
T 818000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE
T 850000000 8MHz 3/4 NONE QAM64 8k 1/4 NONE

Can I compose one, of these by myself (from other nearby citys), or how?

hermann pitton wrote:
> Hi,
>
> Am Sonntag, den 10.02.2008, 15:28 +0100 schrieb Per Blomqvist:
>  =20
>> Hello Jonas Andren.
>> (Kom inte o s=C3=A4g att Anden =C3=A4r dansk)
>>
>> The Harware I have, I have said.  Its the media-card, is this:=20
>> http://www.linuxtv.org/wiki/index.php/Asus_My_Cinema-P7131_Hybrid
>> (running on a amd64, mother-board m2a-vm.. Ink=C3=B6pt p=C3=A5 Kjell&C=
o byggsats=20
>> f=C3=B6r 2 veckor sedan...
>>
>> I also said that the same Media-card did function (somewhat) on my old=
=20
>> computer (a PII330MHz, though with terrible video result). And it work=
s=20
>> in Windows XP. So, the Media-card function.
>>
>> I downloaded&installed  linuxtv-dvb-apps-1.1.1.tar.bz2=20
>> <http://www.linuxtv.org/downloads/linuxtv-dvb-apps-1.1.1.tar.bz2>
>> (and all so called utils: "dvbdate" "dvbtrafick" "scan" and "zap"=20
>> worked. BUT, nothing under the test)
>>    =20
>
> you should prefer dvb-apps from mercurial, but that is not so important=
.
>
>  =20

There is a deb-package called "mercurial".
(I suspect it doesnt have anything, todo with this, no?)

> First of all I would like to see relevant "dmesg" stuff for the card
> and tuner to see if it is still likely the same card, auto detected and
> eeprom content unchanged and all chips alive. If you enable i2c_scan=3D=
1
> you look first for the devices found.
>  =20
I used the linux-kernels-source. in its documents for this. Downloaded=20
the firmware..
(I include dmesg output in the end of this email, anyway. The revision=20
is 20, and not a LifeView fabrication..

> Also we never saw, if your firmware upload is successful and if you use
> preferably revision 29 with such a card with Low Noise Amplifier.
> If not, download it from LifeView with the script in /Documentation/dvb
> and do a cold boot. (recent stuff is in a v4l-dvb mercurial snapshot)
>
> Antenna input for DVB-T is FM/RF input.
>
> Can you point to the initial tuning file you are using or to what you
> believe is a valid channels.conf file for you?
>
> It is always worth a try to set all to AUTO in the initial tuning file,
> except frequency to tune and bandwidth and then use "scan" to create a
> channels.conf.
>  =20

Yes, now my system is relatively fresh, again (I dont load any=20
kernel-module with any extra options).

> If still not, we install the recent v4l-dvb, remove all old modules and
> might try to debug from there.
>
> Cheers,
> Hermann
>
>
>
>  =20

I also tried to compile the kernel (there was this option there=20
VIDEO_ADV_DEBUG). But unfortunately I cut away so other stuff, soo the=20
new kernel got panic at bootup. Another story..

It was the "channel.conf" that was wrong.. Thx again!
(what a fuzz)




--------------010507030709010405050303
Content-Type: application/gzip;
 name="dmesg_1.txt.gz"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="dmesg_1.txt.gz"

H4sICKxgr0cAA2RtZXNnXzEudHh0AOQ7a3fiOLLf+RV1dvaehl0gkmye9/aeJZB0Mx0SNpDp
OTc3h2NsAd4Y2+NHHvPrt0qyeSRAQnrO7ofL9BAsVZWkeqskX7h++gQPMordwAdRrVeFqBgV
a+nUTSj25NS1Vs31EhSX1n38d0c1V4Noji1z217hm1VeNUAw1uCMt6AYRjKSnrRiWVoRIxhR
4Y1SCX7iMBoMYZT6cBk8gAm82cZ/rAU3464iU+gGy6XlO+C5vmxDFATJ5xNHPpzEjlXHRyic
9q9GlTAKHlxHOhAunmPXtjy47gxgaYXtAigA2RSsDezFByqbTa0ZNRXT2Jp6srQPUUNtIVqK
VjGSsYwepLMXdfZqTM7eh8pfTlfMpGRvTncFtY1oKMROd9iHy19G+1GNV6h6BRrVsRJrL+7L
pYrZ7F1LldnfDdRZ3vQG6kzaL1A524F65icycv05WI4zsezEfZCTyPLnssjKgP94rVUCBtJP
IlfGEMzAQEWENJbOYVxRqyN2q47gJeC7CUjfmYQzf4KaCZ+BM7NZa9QLvUEfTcyEkGbpJ9UC
8bcN16PekJZy3hSnNDcm0CIjAZ1xHwBKGdSvo94YxPnZmYHLJSiToHgGBZ3RzUiJyxQGEwgE
ne/XPcg+LKdyjn8UlWZNUzknKsaRVHqruYgmUqkJbuycC31IODAYnY8BDC2ljbmMFBVqVCti
Wc8op99smNQjWF3RH44vxjib4dX3s+vLq+/5vDjAxXi4esrpD7rnXzSVjqLCjO4HONYZ9rua
Sl1TaR7H95Ft+T7p0uXNoANJEAZeMH8Gl1xhlCymkevMJQizcBloEDvwZ+48jayEPO0sSH2n
cG7dK3UEP3AkWMkrD1d56Qr+s/p/iv57KZcQyyQN9aTZO+b8v4EvYXh+CWqwGJ069JAjmx80
+7+pHyZr1XW/IfJOalP9ucUBMXmJYQJWbVv90oq85wnNj0z1VtyBXu3GJApq1Par8YmBW33I
F92neVO48vOFJ0FieaFFK6JOIYxsYb8HFOwQT3Uq1qHAI0DW4XS2gFSc1WC5j9vqFy30Gqq/
DBf98yuYWom9aLMVizKwumgeGm0FyJutWqu+g6LB11zVoGwPQbKQaWBFDjgykXYinSr0XApj
pFqJu5QRRvY0oacAMwtoipqZO8XhoDJWEP0rGKKh4DBPJhpf1n0RUPBXtok6ihyJsT9To9yL
XKjuomWH7sR1btkTY3fgWaFrrx+lT1EVw8UwCmykgrP/CcMI6W8aVrrDm9JeYnybGN9NjO/F
F9v4+Ogo5hCBfTjGNo6xB2dyiZHmxcIX7nwBknwNsj/BRn53GId/AEd8AMc4iNO/0kzQsOZd
Lu5bErdOBO5gHruTKSaftwzxNAb+bEPGKjDLW1qi0crwZdQHVkFrzIa6HE9G193J1S/XUJym
CAv4PXGj3/DX3AumlqceBDgzj/4vvY3Y2kRsgRc8gicf5Br1+h/aZcL0WRkBhgNZXXeKQ52t
HZ0jmSiDUlzLrSsJYOZZSeEmVl0UroqDTm9cUuZKqfl20HH9GRk4/S7Ej3Eah5ilyLkbY1jA
Af0gttBHopkH0TO6oznCvSt3/hAxi70iNvswsX2peaHjeehSFLeG3T752CCN0IghTqxINWPU
zRIYdBBz3HJAnuy2pxkVjPaDIaYMSOuRUExAD4LuU8AiSEIvnavnwvDsGv9quGxMo9FEbzt9
TnQkDdHx2WGqcu/Caep6CUZa8rYerjSuAowppMAqpogaBpxvMkIAFOUbO6m+7yau5bm/08A4
kZ9YYdjvwcKKF5CQM8ljelsH1GIQOTLCYUQZQ3yj3tTzLBUGVqTSkvGoC6kfa1wnlaRv2BZT
47NvL6LAd3/HeEUuv2pj+piFAxDItirjJgy+/o5ZceY0q7gZ9OPAw9nbmCylEfzypfNXaLIn
USt0F9LWuRDyKEkjWa0i/PCGwnDeBH+H+nQmMlnFODbOGwanhU4OkAQBxBjBPCiqnhJlX50v
Q8jSMZ11DZQataFRNzG83p80mjXMd+/BerBcTy22iIM07+E+57wjUdiszhAoj9JlaJm1eyVJ
7GvV79G63KRU6KIEppGWviM96xmNeR0X41Da7sy1MxPGVWKCyYwqJgGnwTwY9IcjKHrhPz83
TVY3mgI1T9pp5CbPcB5ZS/kYRPfwwKvIXjWekjeKYHR2QYUATFl6WeAgvZ6ikiAXrdCauh7R
uBgNttB6pBHPYFv2Qu5UFI67koZYqUqzvEq3Ml3pUy5U2U+gXqsZa1Vr0KbCFM21qqFAkgPo
mHwVlE1dcOhDl+CQpvkNinVT0zgheyiVoZetYkdnRkHk+DUudsIAO1Fp4KVK7zTWMC9IrGN/
v9de9a4auwGqn+4hv2t56Lh8i3JOXEX86GKKlXnsm6FSqMzdK7xIPri6fsNYg3FRzzy6t86G
tPq4lMBHaYi+ooCKmJL/EDXl7Aor6+OiWqO9GdreGrX61rR0tMB5UY5EbSu7BX4iNCUM4K+9
DP+QyrOqqL1WeVZjRunfKHB+wn9Y4JgJDnrQSRZe4BeTZQknBL8K6KVIQwGtcXCB7K8YeWQY
En8YL5wiU+aLBHA3JXQQWbpzHa0ndhAnn41Ws3B5Nt6KhiiZJEAXCjNr6XrPwOuZMlGOkjyH
EkLbVVFSIxQw8rVBq9Rg0L26PO9/IfewUayRM/3RoOg0l0udOkAYxLFLNonqieHGtZFTrM3z
hL1PGhlGqHtRnidnPcU4DUPM8GMYMRhxGBkwMmFUy1MkPZ8sD6R8ZaXceX6Tbxkwbl+jUsKp
duK32IDJYVGFaArOas7I5Wke5Re4OXm0kPU6a8tBxrjzi0Ns95M8IOiMoU0rMqvmxoD91WSu
s2RrrDzT7f9NRqeTKk2hOhlej++OxBmK4eRjiN2zxocQMfwdGhHjxj3cXlx+6yBLMfmMwcD8
pgZ1aKCvB85L8BfMqfP9SPUwkdM/gkj3jyDS+yOInP0RRM53EvkLXxW09uCxD+Lxd05aZQww
pPSV8sohOe6Rtll4YNVWA4p2CTqOtYRT8uqF0MfkeOgP9U6D8ohXfscPN/2OQtDFZu052rgl
xJEuh6zDjEPdXSYOdWP8ONR9eri7ebi7y8wfmFrjMPEaOv0D3eZh7HN+kGvGDzG1m08tF3Fb
58uAibwGjvPaKeFvCT31N8SexlMbA197QxXAl4/awc8sHNSJXCoMIeAsfj/4Ip3uBc5Wsya8
GfTUfCnEoFmsgovq78/AWuEGMvY/JUA5dhkoL/4TxtHPBC9xm/8n3J4huJvAQnoh7v4wMiaI
HUmymDeD9NthXOQFrutxF3MbHx6te9yyRMESA6eWTLJYLfFT/Ix0lp8obYaplP4rw1tSXS8T
IWZ6C4VNss3W+4kCH/+kjH8HYU1EwbTBDZRbUKVTqthxKvPiHz7bHD+rXx5AFKJZoe8j0Uw2
rajvI9GcekV9H4dmq8XZjB+Jxs2K+j4SraZGq4kj0eo2odWdfWjvEn/9DfG/i4j9Dh2yaQF0
dJDPP08+cRF58on7j9SjYg+mZ/Ijq3HeMRHn5URsp67lraZwQAavMGfZ/GeNNya/G7uZYU8/
hG1n2AcYpzycTprbqzyX8SodHvSvkI2+Ezy2QVGi1WPz4Gywap85lpbQzJnqzQHA8Prs/Gzc
/boCcnIxOls7iFejNl6O6uRIr0ad5aPO9o46c+wcyD4wqsrpt0adEtJ016gyJygPjOrkQM7G
qHlp1rMS6dvP2bY3mK23S2se0E67br4dCgp0SNIGVU4Pl2B7gX2vK5drDXWpNOepVK4/VGFN
Hqjk6ApfXoipl+nIiJtmXogZd4cgVanPjRfSeU8xqFUGg5u1hmhuEsFN2G7s7UrQ60oSIrfh
6woxXtWucTbFzall01ADKaJ6YNzWBZsx0M4rii4G7aWFVuPGKmmNrOUsrlarFMrduHAeSanA
qMvJasxtqNVE8x6jr0RSVuq4SXtdOSNwXyYeZdwxSkYmUFwf2CjoIhdM1BstbjaqTUO0eam9
VXn75XzUplrdPfyWBgmK1KG/k3q1VuWFHv0+UBWr8VwKdOKrirkZE90AYsRyUg/7/CDYSse3
Oi0/cW03tJK8or4LyJGWQ9WSvQD27LfNTKyI1mOlXpJtuAejPi7Pje43TgqpDcnScaxFDare
BHT7J8gNxo0zm+FtVkO/8VErs+LYnfuTVV1hsqQ6z7mKITQNe1UYzY8JpDqTxLEionm7SbON
uSD6iLt3gxp3hWtpeUCWDF0yYOjpoPTAq1xYdrYBs+bh3EJK63QXN1+cCbX76tGxx8+Bj6k3
joTK06bTVHbCUfFZHuT+fJ3VD9FEqy0Gf8Z9n6q8lFXCGy8sdeifl2diRYjIYEKZPI8Y1YL6
J1cYVYwZugg60voMZonkYIEaqbMj/VRUfjT9bO6I2JpwQXUfMcPrzqDXH33L6WwYG7Klri6U
oY3eq3MY5Ta+6SMETvdypsrB4uPrhbpNZgq4nzo/utbp67Wuae8b10qffnRca9+4RLuAOz/c
8Y1OBHQD9C+BR2Z9m+0m28OR+FamhxlXD4M7dUvlqc7K+GUCSYKXuVBKFaCLU4S/nfaUAu6A
3Qbs3Py6D1AUlriCbGrLII1lvig6CFM3aNCJeR4QWBZ57E0GvVk1fRuisQoOqa+OZLMDoTxG
qGMfHSJcP0wxRHTGuspIXsohnwUoXvmsr0ugFE9sD73SiYLW3/mm7xw3fLfnncs79Oy+rvDA
2ZMtQ3VyW1xV4ye0/a2wRtPAiNI5m1xejSfnVzeXvfJGobm3cqSUE2b30uA2P164+3eQb8N4
IdV1EnX953b89Rq1p2gy6JYKwcJ2JwsbTROR6tBJ5yluppkJN6NTdGIcPl2F0v8EX2mPvaGY
xauv3X4pc6Q7y2Cr3M+ostvOHZX36T4AeoCiOqEv02F9iZrJN/L6aipbmG2ggV4Ovw+WChA0
cSqJrDWwDDoA0VE+dvjpcoor4PuIKK3HvAzjKyX6dKGBCcpKqeZBFQ3efnGc/xMHexEg73WR
QD2RMSzSKfAK0iWyNC9q0EefW11CR4lVcC6MusipOJ3qTdNWvuK5UyuxNi4aC46MtByK4Ode
EIbP2rkU4xIlyoyUg1dNc1A473WBaU9NFZMKb7U4BjHWaLwlP357upZfY7f8GjvZyY+QHz9O
fmIfESW/xgv5ORvyE8fIT+yXn9grvzf4KW67a342d/OzuXN54gh+iuP4aewjovjZfMFPe4Of
xjH8NPbz0/goP40P66dxBD+N4/hp7iOyUz+nG/w0j+GnuZ+f5kf5aX5YP80j+Gkex8/aPiI7
9dPa4GftGH7W9vOz9lF+1m57a362dvOzVZA7lodTP9vFzz2wx/Czvo+II6fpXGeDfB+M4nnr
Bc9bxPM9CDQrgRtCdduLpqSWhdykkzCdDHOG+YxNeYiZS65+jOTq+yW36sIxXoguavJ6C764
c9yBJnCGyTlmlkk+JwyvF98qlx1M0nSQPSBq0abLVpupzl5RH7GR1lSzjbRMFoyOJS5w0s3p
SZNzPtUpO1XBbHUji6tLumV1OWDantnt+qw9a7QbopyPbqGI1uIRxJeNdOKwMoutFQqxc4VC
7BrDXmePtkXnOw6tibjeG3TKtI2w1U09gU2FG9+lK5IwSL3ErQyRR+rxrNLvneXCWe+2ca/P
LC9cWKLgOrhX6cRxulTEDLp9k6VRpPxxKLNL1MP+FVAdIv7v1e1OvXVzyQDiz09PO7aCjty9
CSR9rVca2gLVbVs9EKliJk59FWdlHrQTzO/MijX++9R96+4PjTFAC4dREkRUXtOzpXt7sR27
DFDVKJ+Uy9TL33mIdmBlJ4vHHBpWYo1ceEUtu3OyQaRa2EBo51zRW2ZUYbHd/Wi5yjhoqhko
mkCMJuNJ5P6M7vPE2Zsfu5StQ+6FrKFKd7LoemLsBWj3WUEGDPgyDdVtZXCXoQejzrij1GEX
sZlnzWOUrf0buJ59D+ES6GKf7QX4M4SQKnFeuoSQykeK6RyZToTUg9h8MDYfzPwBU3rMXPUk
rCe4QYs44YYB9tLZNu6ZWo6deEC3zrc/MF06S2tXh7pVLWgU8d5Rmj8yivHOUcQPrcV87yg/
tJZcLqrInIaAe0StO8XRKLES9ClcGGhh2rvRFeaSQkOXRGWIDln1d9x6fe/RBcFvowpjg5/V
e2ioW7zLjPLWAta4ZrNptBro6FHtbbSLGAHJGwLO6OK0YzZhDbtRolfGvUFMbM7fCR799cTZ
62kbR0Gb74cmdceZM/Uf9NwI11Tp2FTIUG/3EBn1eckrxScY/oPeg+lcjjA01Qqj0zpjkyHi
tIECwkZoQVdCoYusffP4iR8OawjwrhrF5sD2wg3RIa0vjbKtbqrIoK3+F+hrnsq5oF9zPY/q
W1NJKhar4B+p15wwtiBjTgcVeudIxXRp6lNZk+FugV7UVP4PHR76ooVjtdHvlPHHlH4U8mt3
xI61qyaiKhA4a97fxo51t6FdNS4qdGqxvq2X6RsUSQq1lrq//ZrC98hN1KVKyqSorhDMZjvA
BlTrH0k/VueBYFj0TW8X7CFo66uiWZG8jOy1nFeN+RWRPMz0hleAen9+0/n/tFRAWm364vQl
4H/oTw3Uiwj41aCvJn214G87JtFJEhrL0ekB1eQLpFYwHo3GmAKE0O31ful9h9HXykgw8XOZ
jBQz4W7vBNsr11cDnQoUSAehT6o7vuhUDFZj9CYnWfT6IECTVj8hplyrySqP6AVwveqtBpWP
q+TEctW6PXepUwDyjjqbokvb9A6doYnF0tMXrdVxEnsyhZ7Jq/YaZYVMGxXGgwp9N8p0hlGn
27RqM7P7zql2EIY6TXpX3jvDJdGyJrRZRf/v0Mv0s8cKPW4n9ppoWe+X8/ybVznTi9OsNpu/
Qs5r9bdCxydd/HFy/V1zk16IMJv3p/qOdVlxqGgYpVUK3f1XM1fb2ygOhL/zK/yx1YXU5i0E
aaXtS3KtditFm9yLVFUVJfTChQQWkjT99zePbQhpiVJ1++Ek5BAYBjOMx894Zmi8qiZotrsW
VwKDhIv45zomJxOxF5Si+N+SC3XW547wLYfvxoojRM/BUGHPZ7bPibK6+eX1+AtiOu6ZcM88
W/dGYAKQvFQo9Sldl7NYLVprtUa1paSgRqCBNtOPi8ZD00Pjo+lLIk46XUtbIdaIBtBKw9Wn
OhXt6ZmzE66nSAYcXcQyfntq0AiIF7nWsiUSxZHMv4iN+b/ZuliG6bQuT+oyhk8oJDo+uCFa
FxLJltPSGPw9sc0nMssLlFHgjZMOa69D+hQyRkzHUaUi1bIdDQPRIqySpzQc1JTJD0+Zv8fL
uEgiJrH8+IpebYhINCpkCRTsTZm8yUwcZXY53GcmDjOzjvfsdp+ZdZiZfZTZ7Xifmf2a2XQn
MbJyj6+tXBEvso2yOLB3NbmQ5NF7yS1JPn0vuS3J4yPkOVxDVcem7NA1jQ+ZFow/soRB2wl6
0q5rlLM8mpGHSohrOUVc6xV9jYmqcPfuYqeKk40u2TiPwzmQU1tUTOjguMoLiMJclnfVACNg
G0Jn3MiTZOs8lAuV5l+DKnoJKsrfPKaV3SjDsCdsfmYTitw4qVVZqMoW8q7VFc7xdRcypN6+
dRbt1lnoW9qydrX2PJtcMAdvEAvD2lbxk/ZEp1qgQfkLQfAFoqbkYSA/iWNyb/CsQzZYaXLs
wPF7XkfVaAfySwaT+BsbEblg1y+ofGB3EZ37IoTVCderrFqVut/jqoKWCAIF7B84mwRAUMHC
q5eoiB16SnbScpf2N2vt3SOxIhbHOayj9D1sLJX1PJqAmOuQPJiIAGboOG2EJ+iv67KpxchQ
9w+yEnCen/TGZUus6iNt2yFW8gslgp4bLdkQGvnYEXLHl/xJs9z3sLKbvXrfdoiVo1iRxsGT
JVF4kBt1ybYgH7flYQ+xcj+vV97nsep9gNURT8t6l6e1Wi+xJkweoPOofC09Yr/S4EPR7K7D
p9U4uFkMtjJNoZoyBts8JbNZEDJH3kLrOLDfLvPlYQFM8pBHv5ry0X+b8tFgbuz2ZXJpP9BJ
7KrofL8iBFKtLuAQL6GHl1R9rGRr93xpsFgPVVnj0agz+XEznpxPBp3BaHT/SprajWTqaLUK
iSVm8YpS1hXAyaWTK3ImrD7/reeGgKgPKFKMAvbHcr6E5w9Uk8rVh/Pvl+Rxycx9WUhMhs1U
Lq9cxYQnC5/0s/vU1ODG2qV+HXIC4+wOM839MdrHhB8hKcJpknHj6s+L3VmVjfhMnadpEjkS
DRXtviUlYdDwwOTITkazJE3ykk2uzgksO941of0Lc3Iq5UT+HR3b7mS0zlmepqUUtuPLFe6Q
MCNOyQTVxiVKPwknL6S72yhwZabJsrlBHgquE31X+K43Z+VzmMMpqkraXQK+oyLJUPocmILF
W+rzqgwEC6MiK2lHXylBMBuOcTE80I5CCQSimQbTRpplGDgZUhareV3J01yEeY501CSLVmmA
b5sRuDPlP1kE7pmCm8I6rXMhSqSTTRfmFNbjK72ZWbjqEnT+CHTf9brX0uuPgPtf6kT//9AJ
/5M6IeNrAVORK72G2n7waBYYJwUKdnX1pJWbMHohI08aCaUua1CbPdPwu1ivVkipGg5P2y1/
7fK/Ib8b/fVjeN/O7vL2ADu3lR3Iwe7iXkfvlhm7GW08lSdO3rTO2jL+A9l9NGVBUAAA
--------------010507030709010405050303
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
linux-dvb mailing list
linux-dvb@linuxtv.org
http://www.linuxtv.org/cgi-bin/mailman/listinfo/linux-dvb
--------------010507030709010405050303--
